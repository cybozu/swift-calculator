import CalculatorCore
import SwiftUI

extension Operator {
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
