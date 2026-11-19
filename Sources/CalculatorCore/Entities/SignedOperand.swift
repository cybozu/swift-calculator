import Foundation

struct SignedOperand: Equatable, Sendable {
    var value: Decimal
    var cost: Int
}

extension SignedOperand {
    func addingValue(with: SignedOperand) -> Decimal {
        value + with.value
    }

    func subtractingValue(with: SignedOperand) -> Decimal {
        value - with.value
    }

    func multiplyingValue(by: SignedOperand) -> Decimal {
        value * by.value
    }

    func dividingValue(by: SignedOperand) -> Decimal {
        value / by.value
    }

    func remainderValue(by: SignedOperand) -> Decimal {
        value.truncatingRemainder(dividingBy: by.value)
    }
}

private extension Decimal {
    func truncatingRemainder(dividingBy divisor: Decimal) -> Decimal {
        var quotient = self / divisor
        var truncated = Decimal()
        NSDecimalRound(&truncated, &quotient, 0, sign == divisor.sign ? .down : .up)
        return self - truncated * divisor
    }
}

extension Decimal {
    /// The number of significant digits that a calculation result keeps.
    ///
    /// Decimal holds up to 38 significant digits, and the error of each operation
    /// accumulates from the last of them. Rounding with a margin of 8 digits absorbs it,
    /// so that `1÷3×3` evaluates to `1` instead of `0.99999999999999999999999999999999999999`.
    static let significantDigits = 30

    /// Rounds the value to ``significantDigits`` significant digits.
    /// Only a formula's final result is rounded, so that an intermediate result keeps its full precision.
    func roundingValue() -> Decimal {
        guard isFinite, !isZero else {
            return self
        }
        let mantissaDigits = String(describing: significand.magnitude).count
        // The scale counts the decimal places to keep, and becomes negative for a large integer.
        let scale = Self.significantDigits - (Int(exponent) + mantissaDigits)
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, .plain)
        return result
    }
}
