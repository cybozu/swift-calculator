import Foundation

/// A state machine that builds calculation tokens from calculator button inputs.
public struct CalculatorEngine {
    /// The tokens that represent the formula under editing.
    ///
    /// The equal input does not fold the tokens into the result. It closes the formula with
    /// ``Operator/equal`` instead, so that `1÷3=×3=` is kept as is and calculated as `(1÷3)×3`
    /// without rounding the result in between.
    /// An input that edits the digits of the result, such as a number, the period, clear, or delete,
    /// first replaces the closed formula with its rounded result.
    /// The plus-minus negates the result by continuing the formula with `×-1=` instead.
    public internal(set) var tokens = [Token]()
    /// The error that occurred in the last calculation, or `nil` when there is no error.
    public internal(set) var error: CalculationError?
    /// Whether the last operand in the tokens is being edited.
    public internal(set) var isEditingOperand = false

    /// Creates a new calculator engine.
    public init() {}

    /// Resets the tokens with the given decimal value.
    /// - Parameters:
    ///   - decimalValue: The value to seed the tokens with, or `nil` to empty them.
    public mutating func reset(with decimalValue: Decimal?) {
        tokens = decimalValue.map([Token].init(decimalValue:)) ?? []
        isEditingOperand = false
        error = nil
    }

    /// Handles the input of a number button.
    /// - Parameters:
    ///   - input: The number that was input. A value outside the range 0...9 is ignored.
    public mutating func handle(number input: Int) {
        guard (0 ... 9).contains(input) else {
            return
        }
        settleResult()
        switch tokens.last {
        case var .operand(value):
            if value.digits == [.number(0)] {
                value.digits = [.number(input)]
            } else {
                value.digits.append(.number(input))
            }
            tokens[tokens.count - 1] = .operand(value)
            isEditingOperand = true
        case .operator:
            tokens.append(.operand(.init(digits: [.number(input)])))
            isEditingOperand = true
        case .none:
            tokens.append(.operand(.init(digits: [.number(input)])))
            isEditingOperand = true
        }
    }

    /// Handles the input of the period button.
    public mutating func handlePeriod() {
        settleResult()
        switch tokens.last {
        case var .operand(value):
            guard !value.digits.contains(.period) else {
                return
            }
            value.digits.append(.period)
            tokens[tokens.count - 1] = .operand(value)
            isEditingOperand = true
        case .operator, .none:
            tokens.append(.operand(.init(digits: [.number(0), .period])))
            isEditingOperand = true
        }
    }

    /// Handles the input of an operator button.
    /// Passing ``Operator/equal`` calculates the current tokens.
    /// - Parameters:
    ///   - input: The operator that was input.
    public mutating func handle(operator input: Operator) {
        guard input != .equal else {
            handleCalculate()
            return
        }
        switch tokens.last {
        case .operand, .operator(.equal):
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
                case .operand, .operator(.equal):
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
            case .equal:
                break
            }
        case .none:
            if input != .subtraction {
                tokens.append(.operand(.init(digits: [.number(0)])))
                isEditingOperand = true
            }
            tokens.append(.operator(input))
        }
    }

    /// Handles the input of the plus-minus button, toggling the sign of the last operand.
    public mutating func handlePlusMinus() {
        // Negating a result as ×-1 keeps the formula exact, so that 1÷3= ± ×3= evaluates to -1.
        if tokens.endsWithEqual {
            tokens += [.operator(.multiplication), .operator(.subtraction), .operand(.init(digits: [.number(1)])), .operator(.equal)]
            return
        }
        guard case .operand = tokens.last else {
            return
        }
        switch tokens.dropLast().last {
        case .operand: // operand operand
            fatalError("Error: There are two or more consecutive operands.")
        case let .operator(value):
            switch tokens.dropLast(2).last {
            case .operand, .operator(.equal): // operand operator operand, or result operator operand
                switch value {
                case .addition:
                    tokens[tokens.count - 2] = .operator(.subtraction)
                case .subtraction:
                    tokens[tokens.count - 2] = .operator(.addition)
                case .multiplication, .division, .modulus:
                    tokens.insert(.operator(.subtraction), at: tokens.count - 1)
                case .equal:
                    break
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

    mutating func handleCalculate() {
        guard !tokens.endsWithEqual else {
            return
        }
        do {
            _ = try tokens.calculated()
            tokens.append(.operator(.equal))
            isEditingOperand = false
            error = nil
        } catch let error as CalculationError {
            switch error {
            case .undefined:
                self.error = error
                tokens.removeAll()
                isEditingOperand = false
            case .invalidFormula:
                // A lone settled value is not a calculable formula,
                // but the equal input confirms it as the result.
                if tokens.isSettledValue {
                    isEditingOperand = false
                    self.error = nil
                }
            }
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    /// Handles the input of the all-clear button, removing all tokens and the error.
    public mutating func handleAllClear() {
        tokens.removeAll()
        isEditingOperand = false
        error = nil
    }

    /// Handles the input of the clear button, removing the operand under editing.
    public mutating func handleClear() {
        settleResult()
        if case .operand = tokens.last {
            tokens.removeLast()
        }
        isEditingOperand = false
    }

    /// Handles the input of the delete button, removing the last digit or operator.
    public mutating func handleDelete() {
        settleResult()
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
        isEditingOperand = if case .operand = tokens.last {
            true
        } else {
            false
        }
    }

    // Replaces a formula closed by the equal sign with its rounded result before an input edits the result itself.
    private mutating func settleResult() {
        guard tokens.endsWithEqual else {
            return
        }
        // The engine closes a formula only after calculating it, so the calculation succeeds again.
        guard let result = try? tokens.calculated() else {
            fatalError("Error: A formula closed by the equal sign is not calculable.")
        }
        tokens = result
    }
}
