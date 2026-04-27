import SwiftUI

/// A type that represents the calculation operator.
public enum Operator: String, Sendable, CaseIterable, CustomStringConvertible {
    case addition
    case subtraction
    case multiplication
    case division
    case modulus

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
        }
    }

    /// An Image that represents the calculation operator.
    public var image: Image {
        switch self {
        case .addition:
            Image(systemName: "plus")
        case .subtraction:
            Image(systemName: "minus")
        case .multiplication:
            Image(systemName: "multiply")
        case .division:
            Image(systemName: "divide")
        case .modulus:
            Image(systemName: "percent")
        }
    }
}
