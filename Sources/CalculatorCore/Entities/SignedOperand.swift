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

    // The truncating remainder: the result takes the sign of the dividend,
    // consistently with the % operator of Swift.
    func remainderValue(by: SignedOperand) -> Decimal {
        let a = NSDecimalNumber(decimal: value).doubleValue
        let b = NSDecimalNumber(decimal: by.value).doubleValue
        return Decimal(a.truncatingRemainder(dividingBy: b)).roundingValue()
    }
}

private extension Decimal {
    func roundingValue() -> Decimal {
        let v = NSDecimalNumber(decimal: self).doubleValue
        return Decimal(round(v * 10000000)) / 10000000
    }
}
