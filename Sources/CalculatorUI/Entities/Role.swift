import SwiftUI

/// A type that represents the calculation role.
public enum Role: Sendable {
    case number(Int)
    case period
    case `operator`(Operator)
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
