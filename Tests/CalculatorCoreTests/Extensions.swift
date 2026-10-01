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

extension CalculatorEngine {
    var expression: String {
        if let error {
            error.localizedDescription
        } else {
            CalculatorFormatter().expression(from: tokens)
        }
    }
}

extension [Token] {
    init(_ formula: String) {
        self = []
        var digits = [Digit]()
        for character in formula {
            if let digit = Digit(character) {
                digits.append(digit)
            } else if let value = Operator.allCases.first(where: { $0.description == String(character) }) {
                if !digits.isEmpty {
                    append(.operand(.init(digits: digits)))
                    digits = []
                }
                append(.operator(value))
            } else {
                fatalError("Error: \(character) is not a calculation token.")
            }
        }
        if !digits.isEmpty {
            append(.operand(.init(digits: digits)))
        }
    }
}
