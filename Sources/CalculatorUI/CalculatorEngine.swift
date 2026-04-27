import Foundation
import Observation

@MainActor @Observable
final class CalculatorEngine {
    var rows: [Row]
    var modifiedDate = Date.distantPast
    var error: CalculatorError?

    var isClear: Bool {
        didSet {
            rows[0].cells[1].role = .command(isClear ? .clear : .allClear)
        }
    }

    var requests: [Request] {
        didSet {
            modifiedDate = .now
        }
    }

    var expression: String {
        if let error {
            error.localizedDescription
        } else if requests.isEmpty {
            "0"
        } else {
            requests.map(String.init(describing:)).joined()
        }
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
        isClear = false
        requests = []
    }

    func setValue(_ value: String) {
        isClear = false
        requests = if let decimalValue = Decimal(string: value) {
            .init(decimalValue: decimalValue)
        } else {
            []
        }
        error = nil
    }

    func onTap(_ role: Role) {
        switch role {
        case let .number(value):
            handle(number: value)
        case .period:
            handlePeriod()
        case let .operator(value):
            handle(operator: value)
        case let .command(value):
            handle(command: value)
        }
    }

    private func handle(number input: Int) {
        switch requests.last {
        case var .term(value):
            if value.digits == [.number(0)] {
                value.digits = [.number(input)]
            } else {
                value.digits.append(.number(input))
            }
            requests[requests.count - 1] = .term(value)
        case .operator:
            requests.append(.term(.init(digits: [.number(input)])))
            isClear = true
        case .none:
            requests.append(.term(.init(digits: [.number(input)])))
            isClear = true
        }
    }

    private func handlePeriod() {
        switch requests.last {
        case var .term(value):
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            requests[requests.count - 1] = .term(value)
        case .operator, .none:
            requests.append(.term(.init(digits: [.number(0), .period])))
            isClear = true
        }
    }

    private func handle(operator input: Operator) {
        switch requests.last {
        case .term:
            requests.append(.operator(input))
        case let .operator(value):
            switch value {
            case .addition:
                requests.removeLast()
                requests.append(.operator(input))
            case .subtraction:
                guard input != .subtraction else {
                    return
                }
                switch requests.dropLast().last {
                case .term:
                    requests.removeLast()
                    requests.append(.operator(input))
                case .operator:
                    requests.removeLast(2)
                    requests.append(.operator(input))
                case .none:
                    requests.removeAll()
                }
            case .multiplication, .division, .modulus:
                if input != .subtraction {
                    requests.removeLast()
                }
                requests.append(.operator(input))
            }
        case .none:
            if input != .subtraction {
                requests.append(.term(.init(digits: [.number(0)])))
                isClear = true
            }
            requests.append(.operator(input))
        }
    }

    private func handle(command input: Command) {
        switch input {
        case .plusMinus:
            guard case .term = requests.last else {
                return
            }
            switch requests.dropLast().last {
            case .term: // term term
                fatalError("Error: There are two or more consecutive terms.")
            case let .operator(value):
                switch requests.dropLast(2).last {
                case .term: // term operator term
                    switch value {
                    case .addition:
                        requests[requests.count - 2] = .operator(.subtraction)
                    case .subtraction:
                        requests[requests.count - 2] = .operator(.addition)
                    case .multiplication, .division, .modulus:
                        requests.insert(.operator(.subtraction), at: requests.count - 1)
                    }
                case let .operator(preValue): // operator operator term
                    switch (preValue, value) {
                    case (.multiplication, .subtraction),
                        (.division, .subtraction),
                        (.modulus, .subtraction):
                        requests.remove(at: requests.count - 2)
                    default:
                        fatalError("Error: There are two or more consecutive operators.")
                    }
                case .none: // operator term
                    if value == .subtraction {
                        requests.removeFirst()
                    } else {
                        requests.insert(.operator(.subtraction), at: 1)
                    }
                }
            case .none: // term
                requests.insert(.operator(.subtraction), at: 0)
            }
        case .calculate:
            do {
                requests = try requests.calculated()
                isClear = false
            } catch let error as CalculatorError {
                switch error {
                case .undefined:
                    self.error = error
                    requests.removeAll()
                    isClear = false
                case .invalidFormula:
                    break
                }
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        case .allClear:
            error = nil
            requests.removeAll()
        case .clear:
            if case .term = requests.last {
                requests.removeLast()
            }
            isClear = false
        case .delete:
            switch requests.last {
            case var .term(value):
                value.digits.removeLast()
                if value.digits.isEmpty {
                    requests.removeLast()
                } else {
                    requests[requests.count - 1] = .term(value)
                }
            case .operator:
                requests.removeLast()
            case .none:
                return
            }
            if requests.isEmpty {
                isClear = false
            }
        }
    }
}
