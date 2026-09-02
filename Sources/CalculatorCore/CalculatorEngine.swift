import Foundation

public struct CalculatorEngine {
    var tokens = [Token]()
    var error: CalculationError?
    public internal(set) var isEditingOperand = false

    // TODO: Formatterに置き換える
    public var expression: String {
        if let error {
            error.localizedDescription
        } else if tokens.isEmpty {
            "0"
        } else {
            tokens.map(String.init(describing:)).joined()
        }
    }

    public init() {}

    public mutating func reset(with decimalValue: Decimal?) {
        tokens = decimalValue.map([Token].init(decimalValue:)) ?? []
        isEditingOperand = false
        error = nil
    }

    public mutating func handle(number input: Int) {
        switch tokens.last {
        case var .operand(value):
            if value.digits == [.number(0)] {
                value.digits = [.number(input)]
            } else {
                value.digits.append(.number(input))
            }
            tokens[tokens.count - 1] = .operand(value)
        case .operator:
            tokens.append(.operand(.init(digits: [.number(input)])))
            isEditingOperand = true
        case .none:
            tokens.append(.operand(.init(digits: [.number(input)])))
            isEditingOperand = true
        }
    }

    public mutating func handlePeriod() {
        switch tokens.last {
        case var .operand(value):
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            tokens[tokens.count - 1] = .operand(value)
        case .operator, .none:
            tokens.append(.operand(.init(digits: [.number(0), .period])))
            isEditingOperand = true
        }
    }

    public mutating func handle(operator input: Operator) {
        switch tokens.last {
        case .operand:
            tokens.append(.operator(input))
        case let .operator(value):
            switch value {
            case .addition:
                tokens.removeLast()
                tokens.append(.operator(input))
            case .subtraction:
                guard input != .subtraction else {
                    return
                }
                switch tokens.dropLast().last {
                case .operand:
                    tokens.removeLast()
                    tokens.append(.operator(input))
                case .operator:
                    tokens.removeLast(2)
                    tokens.append(.operator(input))
                case .none:
                    tokens.removeAll()
                }
            case .multiplication, .division, .modulus:
                if input != .subtraction {
                    tokens.removeLast()
                }
                tokens.append(.operator(input))
            }
        case .none:
            if input != .subtraction {
                tokens.append(.operand(.init(digits: [.number(0)])))
                isEditingOperand = true
            }
            tokens.append(.operator(input))
        }
    }

    public mutating func handlePlusMinus() {
        guard case .operand = tokens.last else {
            return
        }
        switch tokens.dropLast().last {
        case .operand: // operand operand
            fatalError("Error: There are two or more consecutive operands.")
        case let .operator(value):
            switch tokens.dropLast(2).last {
            case .operand: // operand operator operand
                switch value {
                case .addition:
                    tokens[tokens.count - 2] = .operator(.subtraction)
                case .subtraction:
                    tokens[tokens.count - 2] = .operator(.addition)
                case .multiplication, .division, .modulus:
                    tokens.insert(.operator(.subtraction), at: tokens.count - 1)
                }
            case let .operator(preValue): // operator operator operand
                switch (preValue, value) {
                case (.multiplication, .subtraction),
                    (.division, .subtraction),
                    (.modulus, .subtraction):
                    tokens.remove(at: tokens.count - 2)
                default:
                    fatalError("Error: There are two or more consecutive operators.")
                }
            case .none: // operator operand
                if value == .subtraction {
                    tokens.removeFirst()
                } else {
                    tokens.insert(.operator(.subtraction), at: 1)
                }
            }
        case .none: // operand
            tokens.insert(.operator(.subtraction), at: 0)
        }
    }

    public mutating func handleCalculate() {
        do {
            tokens = try tokens.calculated()
            isEditingOperand = false
        } catch let error as CalculationError {
            switch error {
            case .undefined:
                self.error = error
                tokens.removeAll()
                isEditingOperand = false
            case .invalidFormula:
                break
            }
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    public mutating func handleAllClear() {
        tokens.removeAll()
        error = nil
    }

    public mutating func handleClear() {
        if case .operand = tokens.last {
            tokens.removeLast()
        }
        isEditingOperand = false
    }

    public mutating func handleDelete() {
        switch tokens.last {
        case var .operand(value):
            value.digits.removeLast()
            if value.digits.isEmpty {
                tokens.removeLast()
            } else {
                tokens[tokens.count - 1] = .operand(value)
            }
        case .operator:
            tokens.removeLast()
        case .none:
            return
        }
        if tokens.isEmpty {
            isEditingOperand = false
        }
    }
}
