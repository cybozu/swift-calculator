import SwiftUI

/// A type that represents the calculation command.
public enum Command: String, Sendable, CaseIterable {
    /// The command that toggles the sign of the operand.
    case plusMinus
    /// The command that clears all input.
    case allClear
    /// The command that clears the operand under editing.
    case clear
    /// The command that deletes the last input.
    case delete

    /// A text describing the calculation command.
    public var text: Text {
        switch self {
        case .plusMinus:
            Text(Image(systemName: "plus.slash.minus"))
        case .allClear:
            Text(verbatim: "AC")
        case .clear:
            Text(verbatim: "C")
        case .delete:
            Text(Image(systemName: "delete.backward"))
        }
    }
}
