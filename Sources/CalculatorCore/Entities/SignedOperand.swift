import Foundation

struct SignedOperand: Equatable, Sendable {
    var value: Decimal
    var cost: Int
}

extension SignedOperand {
    func addingValue(with: SignedOperand) -> Decimal {
        (value + with.value).roundingValue()
    }

    func subtractingValue(with: SignedOperand) -> Decimal {
        (value - with.value).roundingValue()
    }

    func multiplyingValue(by: SignedOperand) -> Decimal {
        (value * by.value).roundingValue()
    }

    func dividingValue(by: SignedOperand) -> Decimal {
        (value / by.value).roundingValue()
    }

    func remainderValue(by: SignedOperand) -> Decimal {
        value.truncatingRemainder(dividingBy: by.value).roundingValue()
    }
}

private extension Decimal {
    func truncatingRemainder(dividingBy divisor: Decimal) -> Decimal {
        var quotient = self / divisor
        var truncated = Decimal()
        NSDecimalRound(&truncated, &quotient, 0, sign == divisor.sign ? .down : .up)
        return self - truncated * divisor
    }

    func roundingValue() -> Decimal {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, 7, .plain)
        return result
    }
}
