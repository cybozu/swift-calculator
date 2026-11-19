import Foundation

/// A value under calculation, which stays an exact fraction as long as it fits.
///
/// An operation on two exact fractions is exact. When the fraction overflows,
/// the calculation continues approximately in `Decimal`.
enum Number: Equatable, Sendable {
    case exact(Rational)
    case approximate(Decimal)

    init?(_ operand: Operand) {
        if let rational = Rational(operand) {
            self = .exact(rational)
        } else if let decimalValue = operand.decimalValue {
            self = .approximate(decimalValue)
        } else {
            return nil
        }
    }

    var decimalValue: Decimal {
        switch self {
        case let .exact(rational):
            rational.decimalValue
        case let .approximate(decimal):
            decimal
        }
    }

    var isZero: Bool {
        switch self {
        case let .exact(rational):
            rational.isZero
        case let .approximate(decimal):
            decimal.isZero
        }
    }

    var negated: Number {
        switch self {
        case let .exact(rational):
            .exact(rational.negated)
        case let .approximate(decimal):
            .approximate(-decimal)
        }
    }
}

extension Number {
    func adding(_ other: Number) -> Number {
        combined(with: other, exactly: { $0.adding($1) }, approximately: { $0 + $1 })
    }

    func subtracting(_ other: Number) -> Number {
        combined(with: other, exactly: { $0.subtracting($1) }, approximately: { $0 - $1 })
    }

    func multiplied(by other: Number) -> Number {
        combined(with: other, exactly: { $0.multiplied(by: $1) }, approximately: { $0 * $1 })
    }

    /// The divisor must not be zero.
    func divided(by other: Number) -> Number {
        combined(with: other, exactly: { $0.divided(by: $1) }, approximately: { $0.dividingKeepingSignificantDigits(by: $1) })
    }

    /// Returns the truncating remainder, which takes the sign of the dividend. The divisor must not be zero.
    func truncatingRemainder(dividingBy other: Number) -> Number {
        combined(
            with: other,
            exactly: { $0.truncatingRemainder(dividingBy: $1) },
            approximately: { $0.truncatingRemainder(dividingBy: $1) }
        )
    }

    private func combined(
        with other: Number,
        exactly: (Rational, Rational) -> Rational?,
        approximately: (Decimal, Decimal) -> Decimal
    ) -> Number {
        if case let (.exact(lhs), .exact(rhs)) = (self, other), let result = exactly(lhs, rhs) {
            return .exact(result)
        }
        return .approximate(approximately(decimalValue, other.decimalValue))
    }
}

extension Decimal {
    /// The number of significant digits that a calculation result keeps.
    ///
    /// A result that does not terminate as a decimal, such as `1÷3`, carries its error in the last of
    /// the 38 significant digits of Decimal, and so does a result calculated approximately after an exact
    /// fraction overflowed. Rounding with a margin of 8 digits absorbs it.
    static let significantDigits = 30

    /// Rounds the value to ``significantDigits`` significant digits.
    /// Only the final result is rounded, when it leaves the calculation as a decimal.
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

    /// Divides the value, keeping 38 significant digits regardless of the magnitude of the quotient.
    ///
    /// The division of Decimal keeps at most 38 decimal places, so a small quotient loses its significant digits,
    /// such as `1÷99999999999999999989` resulting in `0.00000000000000000001`.
    func dividingKeepingSignificantDigits(by divisor: Decimal) -> Decimal {
        guard isFinite, divisor.isFinite, !divisor.isZero,
              let dividendSignificand = UInt128(String(describing: significand.magnitude)),
              let divisorSignificand = UInt128(String(describing: divisor.significand.magnitude)) else {
            return self / divisor
        }
        return Self.quotient(
            dividendSignificand,
            divisorSignificand,
            isNegative: (sign == .minus) != (divisor.sign == .minus),
            exponent: Int(exponent) - Int(divisor.exponent)
        )
    }

    /// Returns `dividend ÷ divisor × 10^exponent` by long division, with 38 significant digits.
    static func quotient(_ dividend: UInt128, _ divisor: UInt128, isNegative: Bool, exponent: Int) -> Decimal {
        var (divisor, exponent) = (divisor, exponent)
        // Multiplying a remainder below the divisor by 10 must not overflow,
        // so a huge divisor drops its last digit, which is far below the 38 significant digits.
        while divisor > UInt128.max / 10 {
            (divisor, exponent) = (divisor / 10, exponent - 1)
        }
        let integerPart = dividend / divisor
        var remainder = dividend % divisor
        var significantDigitCount = integerPart == 0 ? 0 : String(integerPart).count
        var fractionPart = ""
        while remainder != 0, significantDigitCount < 38 {
            remainder *= 10
            let digit = remainder / divisor
            remainder %= divisor
            fractionPart += String(digit)
            if digit != 0 || significantDigitCount > 0 {
                significantDigitCount += 1
            }
        }
        let text = "\(isNegative ? "-" : "")\(integerPart).\(fractionPart.isEmpty ? "0" : fractionPart)e\(exponent)"
        return Decimal(string: text) ?? .nan
    }

    fileprivate func truncatingRemainder(dividingBy divisor: Decimal) -> Decimal {
        var quotient = self / divisor
        var truncated = Decimal()
        NSDecimalRound(&truncated, &quotient, 0, sign == divisor.sign ? .down : .up)
        return self - truncated * divisor
    }
}
