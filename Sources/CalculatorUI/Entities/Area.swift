import SwiftUI

enum Area {
    case main
    case upperSide
    case rightSide

    init(rowIndex: Int, rowLast: Bool) {
        self = if rowLast {
            .rightSide
        } else if rowIndex == .zero {
            .upperSide
        } else {
            .main
        }
    }

    var color: Color {
        switch self {
        case .main:
            Color(.main)
        case .upperSide:
            Color(.upperSide)
        case .rightSide:
            Color(.rightSide)
        }
    }
}
