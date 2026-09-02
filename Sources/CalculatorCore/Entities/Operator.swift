/// A type that represents the calculation operator.
public enum Operator: String, Sendable, CaseIterable, CustomStringConvertible {
    case addition
    case subtraction
    case multiplication
    case division
    case modulus
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
