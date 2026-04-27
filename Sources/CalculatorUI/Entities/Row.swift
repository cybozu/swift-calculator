import SwiftUI

/// A structure that contains cells information.
public struct Row: Identifiable {
    /// The unique identifier.
    public var id = UUID()
    /// An array of cell information.
    public var cells: [Cell]
}
