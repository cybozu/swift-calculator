import Foundation

public struct CalculatorEngine {
    private var requests = [Request]()
    private var error: CalculationError?
    public private(set) var isEditingTerm = false

    // TODO: Formatterに置き換える
    public var expression: String {
        if let error {
            error.localizedDescription
        } else if requests.isEmpty {
            "0"
        } else {
            requests.map(String.init(describing:)).joined()
        }
    }

    public init() {}

    public mutating func reset(with decimalValue: Decimal?) {
        requests = decimalValue.map([Request].init(decimalValue:)) ?? []
        isEditingTerm = false
        error = nil
    }

    public mutating func handle(number input: Int) {
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
            isEditingTerm = true
        case .none:
            requests.append(.term(.init(digits: [.number(input)])))
            isEditingTerm = true
        }
    }

    public mutating func handlePeriod() {
        switch requests.last {
        case var .term(value):
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            requests[requests.count - 1] = .term(value)
        case .operator, .none:
            requests.append(.term(.init(digits: [.number(0), .period])))
            isEditingTerm = true
        }
    }

    public mutating func handle(operator input: Operator) {
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
                isEditingTerm = true
            }
            requests.append(.operator(input))
        }
    }

    public mutating func handlePlusMinus() {
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
    }

    public mutating func handleCalculate() {
        do {
            requests = try requests.calculated()
            isEditingTerm = false
        } catch let error as CalculationError {
            switch error {
            case .undefined:
                self.error = error
                requests.removeAll()
                isEditingTerm = false
            case .invalidFormula:
                break
            }
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    public mutating func handleAllClear() {
        requests.removeAll()
        error = nil
    }

    public mutating func handleClear() {
        if case .term = requests.last {
            requests.removeLast()
        }
        isEditingTerm = false
    }

    public mutating func handleDelete() {
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
            isEditingTerm = false
        }
    }
}
