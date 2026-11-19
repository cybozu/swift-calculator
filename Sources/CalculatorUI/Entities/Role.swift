import CalculatorCore
import SwiftUI

/// A type that represents the calculation role.
public enum Role: Sendable {
    /// The role that inputs a number.
    case number(Int)
    /// The role that inputs a decimal period.
    case period
    /// The role that inputs a calculation operator.
    case `operator`(Operator)
    /// The role that executes a calculation command.
    case command(Command)

    /// A text describing the content of calculation role.
    public var text: Text {
        switch self {
        case let .number(value):
            Text(String(describing: value))
        case .period:
            Text(verbatim: ".")
        case let .operator(value):
            Text(value.image)
        case let .command(value):
            value.text
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case let .number(value):
            "number\(value)Button"
        case .period:
            "periodButton"
        case let .operator(value):
            "\(value.rawValue)Button"
        case let .command(value):
            "\(value.rawValue)Button"
        }
    }
}
