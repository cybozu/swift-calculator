import Foundation

public struct Operand: Equatable, Sendable, CustomStringConvertible {
    var digits: [Digit]

    public var description: String {
        digits.map(String.init(describing:)).joined()
    }

    /// A decimal value that the operand represents, or `nil` when the digits are not a valid number.
    public var decimalValue: Decimal? {
        guard digits.filter({ $0 == .period }).count <= 1 else {
            return nil
        }
        guard digits != [.period] else {
            return nil
        }
        return Decimal(string: description)
    }
}

extension Operand {
    /// Creates an operand that represents the magnitude of the given decimal value.
    /// A sign is represented by a separate subtraction operator token, not by the operand.
    public init(decimalValue: Decimal) {
        self.init(digits: [Digit](decimalValue: decimalValue.magnitude))
    }
}
