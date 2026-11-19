/// A type that represents the calculation operator.
public enum Operator: String, Sendable, CaseIterable, CustomStringConvertible {
    /// The addition operator (+).
    case addition
    /// The subtraction operator (-).
    case subtraction
    /// The multiplication operator (×).
    case multiplication
    /// The division operator (÷).
    case division
    /// The modulus operator (%). The result takes the sign of the dividend.
    case modulus
    /// The equal sign (=) that closes the formula before it.
    /// A formula continued after it takes the result as its first operand.
    case equal

    /// A string that represents the calculation operator.
    public var description: String {
        switch self {
        case .addition:
            "+"
        case .subtraction:
            "-"
        case .multiplication:
            "×"
        case .division:
            "÷"
        case .modulus:
            "%"
        case .equal:
            "="
        }
    }
}
