import Foundation

/// A type that represents an element of the calculation formula.
public enum Token: Equatable, Sendable, CustomStringConvertible {
    /// An operand of the formula.
    case operand(Operand)
    /// An operator of the formula.
    case `operator`(Operator)

    /// A string that represents the token.
    public var description: String {
        switch self {
        case let .operand(value):
            String(describing: value)
        case let .operator(value):
            String(describing: value)
        }
    }
}

extension [Token] {
    /// Creates tokens that represent the given decimal value.
    /// A negative value is represented by a subtraction operator followed by an operand,
    /// and a value without any digit representation, such as NaN, falls back to zero.
    public init(decimalValue: Decimal) {
        self = if decimalValue.isSignMinus, !decimalValue.isNaN {
            [.operator(.subtraction)]
        } else {
            []
        }
        append(.operand(.init(digits: [Digit](decimalValue: decimalValue.magnitude))))
    }

    /// Whether the tokens represent a settled value: a lone value,
    /// or a calculable formula closed by the equal operator, such as an engine's stack right after the equal input.
    /// The calculated value of settled tokens is always available through ``calculatedDecimalValue()``.
    public var isSettledValue: Bool {
        loneValue != nil || (endsWithEqual && (try? evaluated()) != nil)
    }

    /// The value of the tokens when they hold a lone value, such as `5` or `-5`.
    var loneValue: Decimal? {
        if count == 1, case let .operand(operand) = self[0] {
            return operand.decimalValue
        }
        if count == 2, case .operator(.subtraction) = self[0],
           case let .operand(operand) = self[1] {
            return operand.decimalValue.map { -$0 }
        }
        return nil
    }

    var endsWithEqual: Bool {
        last == .operator(.equal)
    }

    /// Returns the calculated result of the tokens as a decimal value.
    /// A lone value is returned as is.
    /// - Throws: A `CalculationError` when the tokens do not form a calculable formula.
    public func calculatedDecimalValue() throws -> Decimal {
        if let loneValue {
            return loneValue
        }
        guard let value = try calculated().loneValue else {
            throw CalculationError.invalidFormula(.incompleteFormula)
        }
        return value
    }

    /// Returns the calculated result of the tokens as a lone value, rounded to the significant digits.
    func calculated() throws -> [Token] {
        [Token](decimalValue: try evaluated().decimalValue.roundingValue())
    }

    /// Returns the exact result of the tokens without rounding.
    ///
    /// A formula continued after an equal sign takes the result before it as its first operand,
    /// so `1÷3=×3` is calculated as `(1÷3)×3`.
    func evaluated() throws -> Number {
        guard !isEmpty else {
            throw CalculationError.invalidFormula(.incompleteFormula)
        }
        var result: Number?
        for segment in split(separator: .operator(.equal), omittingEmptySubsequences: false) {
            guard let first = segment.first else {
                guard result != nil else {
                    throw CalculationError.invalidFormula(.equalWithoutFormula)
                }
                continue
            }
            if case .operand = first, result != nil {
                throw CalculationError.invalidFormula(.operandAfterResult)
            }
            result = try Formula(leading: result, tokens: segment).evaluated()
        }
        guard let result else {
            throw CalculationError.invalidFormula(.incompleteFormula)
        }
        return result
    }
}

/// A formula between equal signs, read as alternating values and operators.
private struct Formula {
    var values: [Number]
    var operators: [Operator]

    /// Reads the tokens, taking a subtraction that does not follow a value as the sign of the next operand.
    init(leading: Number?, tokens: ArraySlice<Token>) throws {
        values = leading.map { [$0] } ?? []
        operators = []
        var isNegative = false
        for token in tokens {
            switch token {
            case let .operand(operand):
                guard values.count == operators.count, let value = Number(operand) else {
                    throw CalculationError.invalidFormula(.incompleteFormula)
                }
                values.append(isNegative ? value.negated : value)
                isNegative = false
            case .operator(.subtraction) where values.count == operators.count && !isNegative:
                isNegative = true
            case let .operator(value):
                guard values.count == operators.count + 1, !isNegative else {
                    throw CalculationError.invalidFormula(.incompleteFormula)
                }
                operators.append(value)
            }
        }
        // A lone value is not a formula, and a formula must not end with an operator or a sign.
        guard !operators.isEmpty, values.count == operators.count + 1, !isNegative else {
            throw CalculationError.invalidFormula(.incompleteFormula)
        }
    }

    /// Calculates %, ÷, and × before - and +, each from left to right.
    func evaluated() throws -> Number {
        var terms = [values[0]]
        var lowOperators = [Operator]()
        for (value, rhs) in zip(operators, values.dropFirst()) {
            switch value {
            case .multiplication, .division, .modulus:
                terms[terms.count - 1] = try Self.operate(terms[terms.count - 1], value, rhs)
            case .addition, .subtraction, .equal:
                lowOperators.append(value)
                terms.append(rhs)
            }
        }
        var result = terms[0]
        for (value, rhs) in zip(lowOperators, terms.dropFirst()) {
            result = try Self.operate(result, value, rhs)
        }
        return result
    }

    private static func operate(_ lhs: Number, _ value: Operator, _ rhs: Number) throws -> Number {
        let result: Number = switch value {
        case .addition:
            lhs.adding(rhs)
        case .subtraction:
            lhs.subtracting(rhs)
        case .multiplication:
            lhs.multiplied(by: rhs)
        case .division:
            try lhs.divided(by: rhs.nonZero())
        case .modulus:
            try lhs.truncatingRemainder(dividingBy: rhs.nonZero())
        case .equal:
            throw CalculationError.invalidFormula(.incompleteFormula)
        }
        // A result beyond the range of Decimal is NaN.
        if case let .approximate(decimal) = result, decimal.isNaN {
            throw CalculationError.undefined
        }
        return result
    }
}

private extension Number {
    func nonZero() throws -> Number {
        guard !isZero else {
            throw CalculationError.undefined
        }
        return self
    }
}
