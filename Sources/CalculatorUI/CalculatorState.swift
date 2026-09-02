import CalculatorCore
import Foundation
import Observation

@MainActor @Observable
final class CalculatorState {
    private var engine = CalculatorEngine()
    private let formatter = CalculatorFormatter()
    var rows: [Row]

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

    init() {
        rows = [
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
                .init(role: .command(.calculate)),
            ]),
        ]
    }

    func setValue(_ value: String) {
        engine.reset(with: Decimal(string: value))
    }

    func toggleClearRole() {
        rows[0].cells[1].role = .command(isEditingOperand ? .clear : .allClear)
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
            case .calculate:
                engine.handleCalculate()
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
