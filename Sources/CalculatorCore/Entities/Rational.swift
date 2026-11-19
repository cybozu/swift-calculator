import Foundation

/// An exact fraction whose numerator and denominator are integers.
///
/// Every operation keeps the result exact by deferring the division to the conversion into a decimal,
/// so that `2÷3×3` is `6/3`, which is reduced to `2`.
/// An operation returns `nil` when the numerator or the denominator overflows `Int128`.
struct Rational: Equatable, Sendable {
    /// The numerator, which carries the sign.
    private(set) var numerator: Int128
    /// The denominator, which is always positive.
    private(set) var denominator: Int128

    /// Creates a reduced fraction, or returns `nil` when the denominator is zero or a value overflows.
    init?(numerator: Int128, denominator: Int128) {
        // Int128.min has no positive counterpart, so it is treated as an overflow.
        guard denominator != 0, numerator != .min, denominator != .min else {
            return nil
        }
        let sign: Int128 = (numerator < 0) == (denominator < 0) ? 1 : -1
        let numeratorMagnitude = numerator.magnitude
        let denominatorMagnitude = denominator.magnitude
        let divisor = Self.greatestCommonDivisor(numeratorMagnitude, denominatorMagnitude)
        self.numerator = sign * Int128(numeratorMagnitude / divisor)
        self.denominator = Int128(denominatorMagnitude / divisor)
    }

    /// Creates the exact fraction that the digits of the operand represent, such as `1234/100` for `12.34`.
    /// Returns `nil` when the digits are not a valid number or do not fit in `Int128`.
    init?(_ operand: Operand) {
        guard operand.decimalValue != nil else {
            return nil
        }
        let parts = operand.description.split(separator: ".", omittingEmptySubsequences: false)
        let fractionPart = parts.count > 1 ? parts[1] : ""
        let numbers = parts[0] + fractionPart
        guard let numerator = Int128(numbers.isEmpty ? "0" : String(numbers)) else {
            return nil
        }
        var denominator: Int128 = 1
        for _ in fractionPart {
            guard let product = Self.multiplied(denominator, 10) else {
                return nil
            }
            denominator = product
        }
        self.init(numerator: numerator, denominator: denominator)
    }

    var isZero: Bool {
        numerator == 0
    }

    var negated: Rational {
        // The numerator is never Int128.min, so its negation does not overflow.
        Rational(uncheckedNumerator: -numerator, denominator: denominator)
    }

    /// The decimal value of the fraction, which is approximate when the division does not terminate.
    var decimalValue: Decimal {
        Decimal.quotient(numerator.magnitude, denominator.magnitude, isNegative: numerator < 0, exponent: 0)
    }

    private init(uncheckedNumerator numerator: Int128, denominator: Int128) {
        self.numerator = numerator
        self.denominator = denominator
    }
}

extension Rational {
    func adding(_ other: Rational) -> Rational? {
        let divisor = Int128(Self.greatestCommonDivisor(denominator.magnitude, other.denominator.magnitude))
        let lhsFactor = other.denominator / divisor
        let rhsFactor = denominator / divisor
        guard let lhs = Self.multiplied(numerator, lhsFactor),
              let rhs = Self.multiplied(other.numerator, rhsFactor),
              case let (sum, false) = lhs.addingReportingOverflow(rhs),
              let commonDenominator = Self.multiplied(denominator, lhsFactor) else {
            return nil
        }
        return Rational(numerator: sum, denominator: commonDenominator)
    }

    func subtracting(_ other: Rational) -> Rational? {
        adding(other.negated)
    }

    func multiplied(by other: Rational) -> Rational? {
        // Cross-reducing first keeps the products small.
        let lhsDivisor = Int128(Self.greatestCommonDivisor(numerator.magnitude, other.denominator.magnitude))
        let rhsDivisor = Int128(Self.greatestCommonDivisor(other.numerator.magnitude, denominator.magnitude))
        guard let product = Self.multiplied(numerator / lhsDivisor, other.numerator / rhsDivisor),
              let commonDenominator = Self.multiplied(denominator / rhsDivisor, other.denominator / lhsDivisor) else {
            return nil
        }
        return Rational(numerator: product, denominator: commonDenominator)
    }

    /// Returns `nil` when the divisor is zero or a value overflows.
    func divided(by other: Rational) -> Rational? {
        guard let reciprocal = Rational(numerator: other.denominator, denominator: other.numerator) else {
            return nil
        }
        return multiplied(by: reciprocal)
    }

    /// Returns the truncating remainder, which takes the sign of the dividend.
    /// Returns `nil` when the divisor is zero or a value overflows.
    func truncatingRemainder(dividingBy other: Rational) -> Rational? {
        guard let quotient = divided(by: other),
              let truncated = Rational(numerator: quotient.numerator / quotient.denominator, denominator: 1),
              let product = other.multiplied(by: truncated) else {
            return nil
        }
        return subtracting(product)
    }

    private static func multiplied(_ lhs: Int128, _ rhs: Int128) -> Int128? {
        let (product, overflow) = lhs.multipliedReportingOverflow(by: rhs)
        return overflow ? nil : product
    }

    private static func greatestCommonDivisor(_ lhs: UInt128, _ rhs: UInt128) -> UInt128 {
        var (a, b) = (lhs, rhs)
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return a == 0 ? 1 : a
    }
}
