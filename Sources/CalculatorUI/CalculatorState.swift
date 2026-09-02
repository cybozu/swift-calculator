import CalculatorCore
import Foundation
import Observation

@MainActor @Observable
final class CalculatorState {
    private var engine = CalculatorEngine()
    private let formatter = CalculatorFormatter()
    // The clear cell always declares allClear here; rows derives the actual role.
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

    // Keeps the ids of baseRows so that the SwiftUI identities stay stable.
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

    func setValue(_ value: String) {
        engine.reset(with: Decimal(string: value))
    }

    func onTap(_ role: Role) {
        switch role {
        case let .number(value):
            engine.handle(number: value)
        case .period:
            engine.handlePeriod()
        case let .operator(value):
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
}
