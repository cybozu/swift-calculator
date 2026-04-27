import SwiftUI

/// A structure that contains calculation role information.
public struct Cell: Identifiable {
    /// The unique identifier.
    public var id = UUID()
    /// The calculation role.
    public var role: Role
}
