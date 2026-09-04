import CalculatorCore
import Foundation
import Observation

@MainActor @Observable
final class CalculatorState {
    private var engine = CalculatorEngine()
    private let formatter = CalculatorFormatter()

    private let baseRows: [Row] = [
        Row(cells: [
            .init(role: .command(.delete)),
            .init(role: .command(.allClear)),
            .init(role: .operator(.modulus)),
            .init(role: .operator(.division)),
        ]),
        Row(cells: [
            .init(role: .number(7)),
            .init(role: .number(8)),
            .init(role: .number(9)),
            .init(role: .operator(.multiplication)),
        ]),
        Row(cells: [
            .init(role: .number(4)),
            .init(role: .number(5)),
            .init(role: .number(6)),
            .init(role: .operator(.subtraction)),
        ]),
        Row(cells: [
            .init(role: .number(1)),
            .init(role: .number(2)),
            .init(role: .number(3)),
            .init(role: .operator(.addition)),
        ]),
        Row(cells: [
            .init(role: .command(.plusMinus)),
            .init(role: .number(0)),
            .init(role: .period),
            .init(role: .operator(.equal)),
        ]),
    ]

    var rows: [Row] {
        baseRows.map { row in
            var row = row
            row.cells = row.cells.map { cell in
                guard case .command(.allClear) = cell.role else {
                    return cell
                }
                var cell = cell
                cell.role = .command(isEditingOperand ? .clear : .allClear)
                return cell
            }
            return row
        }
    }

    var value: Decimal? {
        get {
            guard !engine.isEditingOperand, engine.tokens.isSettledValue else {
                return nil
            }
            return try? engine.tokens.calculatedDecimalValue()
        }
        set {
            engine.reset(with: newValue)
        }
    }

    var expression: String {
        if let error = engine.error {
            error.localizedDescription
        } else {
            formatter.expression(from: engine.tokens)
        }
    }

    var isEditingOperand: Bool {
        engine.isEditingOperand
    }

    func onTap(_ role: Role) {
        switch role {
        case let .number(value):
            discardSettledResult()
            engine.handle(number: value)
        case .period:
            discardSettledResult()
            engine.handlePeriod()
        case let .operator(value):
            discardError()
            engine.handle(operator: value)
        case let .command(value):
            switch value {
            case .plusMinus:
                engine.handlePlusMinus()
            case .allClear:
                engine.handleAllClear()
            case .clear:
                engine.handleClear()
            case .delete:
                engine.handleDelete()
            }
        }
    }

    private func discardSettledResult() {
        if engine.error != nil || (engine.tokens.isSettledValue && !engine.isEditingOperand) {
            engine.handleAllClear()
        }
    }

    // Without this, an operator entered over an error message would grow
    // tokens hidden behind the error text.
    private func discardError() {
        if engine.error != nil {
            engine.handleAllClear()
        }
    }
}
