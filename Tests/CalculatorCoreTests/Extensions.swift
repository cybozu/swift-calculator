@testable import CalculatorCore

extension [Digit] {
    init(doubleValue: Double) {
        self = if abs(doubleValue.truncatingRemainder(dividingBy: 1)).isLess(than: .ulpOfOne) {
            String(describing: Int(doubleValue)).compactMap(Digit.init)
        } else {
            String(describing: doubleValue).compactMap(Digit.init)
        }
    }
}

extension Operand {
    init(_ doubleValue: Double) {
        self.init(digits: [Digit](doubleValue: doubleValue))
    }
}
