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
    /// The modulus operator (%).
    case modulus
    /// The equal sign (=) that folds the formula before it into a result.
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
