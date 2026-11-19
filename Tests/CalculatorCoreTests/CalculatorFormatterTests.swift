import Foundation
import Testing

@testable import CalculatorCore

struct CalculatorFormatterTests {
    @Test(arguments: [
        .init(
            tokens: [],
            expectedString: "0"
        ),
        .init(
            tokens: .init("1+1"),
            expectedString: "2"
        ),
        .init(
            tokens: .init("1+1="),
            expectedString: "2"
        ),
        .init(
            tokens: .init("1+1=+1=+1="),
            expectedString: "4"
        ),
        .init(
            tokens: .init("1-3"),
            expectedString: "-2"
        ),
        .init(
            tokens: .init("3"),
            expectedString: "3"
        ),
        .init(
            tokens: .init("-2"),
            expectedString: "-2"
        ),
        .init(
            tokens: .init("1+"),
            expectedString: CalculationError.invalidFormula(.incompleteFormula).localizedDescription
        ),
        .init(
            tokens: .init("1÷0"),
            expectedString: CalculationError.undefined.localizedDescription
        ),
        .init(
            tokens: .init("1÷0+"),
            expectedString: CalculationError.invalidFormula(.incompleteFormula).localizedDescription
        ),
    ] as [StringCondition])
    func string_from_tokens(_ condition: StringCondition) {
        let actual = CalculatorFormatter().string(from: condition.tokens)
        #expect(actual == condition.expectedString)
    }

    @Test(arguments: [
        .init(
            tokens: [],
            expectedString: "0"
        ),
        .init(
            tokens: .init("1+"),
            expectedString: "1+"
        ),
        .init(
            tokens: .init("-1.2"),
            expectedString: "-1.2"
        ),
        .init(
            tokens: .init("1+1=+1="),
            expectedString: "3"
        ),
        .init(
            tokens: .init("1÷3=×3"),
            expectedString: "0.333333333333333333333333333333×3"
        ),
        .init(
            tokens: .init("1-3=×-2"),
            expectedString: "-2×-2"
        ),
    ] as [StringCondition])
    func expression_from_tokens(_ condition: StringCondition) {
        let actual = CalculatorFormatter().expression(from: condition.tokens)
        #expect(actual == condition.expectedString)
    }

    @Test(arguments: [
        .init(
            tokens: .init("1+1="),
            expectedDecimalValue: 2
        ),
        .init(
            tokens: .init("1+1=+1="),
            expectedDecimalValue: 3
        ),
        .init(
            tokens: .init("1-3="),
            expectedDecimalValue: -2
        ),
        .init(
            tokens: .init("0.1+0.2"),
            expectedDecimalValue: 0.3
        ),
        .init(
            tokens: .init("3"),
            expectedDecimalValue: 3
        ),
        .init(
            tokens: .init("-2"),
            expectedDecimalValue: -2
        ),
    ] as [DecimalValueCondition])
    func calculatedDecimalValue(_ condition: DecimalValueCondition) throws {
        let actual = try condition.tokens.calculatedDecimalValue()
        #expect(actual == condition.expectedDecimalValue)
    }

    @Test(arguments: [
        .init(
            tokens: .init("2÷3×3-2"),
            expectedDecimalValue: 0
        ),
        .init(
            tokens: .init("2÷3×3%2"),
            expectedDecimalValue: 0
        ),
        .init(
            tokens: .init("1÷3+1÷6"),
            expectedDecimalValue: 0.5
        ),
        .init(
            tokens: .init("1÷7×7÷7×7÷7×7"),
            expectedDecimalValue: 1
        ),
        .init(
            tokens: .init("2÷3=×3=-2="),
            expectedDecimalValue: 0
        ),
        .init(
            tokens: .init("1÷99999999999999999989"),
            expectedDecimalValue: Decimal(string: "1.00000000000000000011e-20")!
        ),
        .init(
            tokens: .init("1÷3-0.333333333333333333333333333333"),
            expectedDecimalValue: Decimal(string: "0.000000000000000000000000000000333333333333333333333333333333")!
        ),
    ] as [DecimalValueCondition])
    func calculatedDecimalValue_is_exact_through_division(_ condition: DecimalValueCondition) throws {
        let actual = try condition.tokens.calculatedDecimalValue()
        #expect(actual == condition.expectedDecimalValue)
    }

    @Test(arguments: [
        .init(
            tokens: .init("12345678901234567890×12345678901234567890"),
            expectedDecimalValue: Decimal(string: "152415787532388367501905199875000000000")!
        ),
        .init(
            tokens: .init("1÷12345678901234567891×12345678901234567891"),
            expectedDecimalValue: 1
        ),
    ] as [DecimalValueCondition])
    func calculatedDecimalValue_near_the_bound_of_exact_fractions(_ condition: DecimalValueCondition) throws {
        let actual = try condition.tokens.calculatedDecimalValue()
        #expect(actual == condition.expectedDecimalValue)
    }

    @Test(arguments: [
        .init(
            tokens: .init("123456789012345678901234567890123456789012+1"),
            expectedDecimalValue: Decimal(string: "123456789012345678901234567890000000000000")!
        ),
        .init(
            tokens: .init("12345678901234567890123×12345678901234567890123"),
            expectedDecimalValue: Decimal(string: "152415787532388367504942236885000000000000000")!
        ),
        .init(
            tokens: .init("1÷99999999999999999989+1÷99999999999999999999"),
            expectedDecimalValue: Decimal(string: "2.0000000000000000001200000000000000000e-20")!
        ),
        .init(
            tokens: .init("12345678901234567890123÷0.000000000000000000001"),
            expectedDecimalValue: Decimal(string: "12345678901234567890123000000000000000000000")!
        ),
    ] as [DecimalValueCondition])
    func calculatedDecimalValue_continues_approximately_beyond_exact_fractions(_ condition: DecimalValueCondition) throws {
        let actual = try condition.tokens.calculatedDecimalValue()
        #expect(actual == condition.expectedDecimalValue)
    }

    @Test(arguments: [
        .init("1+1="),
        .init("-5"),
        .init("1÷3=×3="),
    ] as [[Token]])
    func isSettledValue_is_true_for_a_calculable_result(_ tokens: [Token]) throws {
        #expect(tokens.isSettledValue)
        _ = try tokens.calculatedDecimalValue()
    }

    @Test(arguments: [
        .init("1+"),
        .init("1+1=+"),
        .init("1+1=5="),
        .init("1÷0="),
    ] as [[Token]])
    func isSettledValue_is_false_without_a_calculable_result(_ tokens: [Token]) {
        #expect(!tokens.isSettledValue)
    }

    @Test
    func calculatedDecimalValue_error() {
        #expect(throws: CalculationError.invalidFormula(.incompleteFormula)) {
            try [Token]().calculatedDecimalValue()
        }
    }

    @Test
    func engine_calculatedDecimalValue() throws {
        var sut = CalculatorEngine()
        sut.handle(number: 1)
        sut.handle(operator: .addition)
        sut.handle(number: 2)
        #expect(try sut.tokens.calculatedDecimalValue() == 3)
    }

    @Test
    func engine_calculatedDecimalValue_after_equal() throws {
        var sut = CalculatorEngine()
        sut.handle(number: 1)
        sut.handle(operator: .addition)
        sut.handle(number: 2)
        sut.handle(operator: .equal)
        #expect(try sut.tokens.calculatedDecimalValue() == 3)
    }
}

struct StringCondition {
    var tokens: [Token]
    var expectedString: String
}

struct DecimalValueCondition {
    var tokens: [Token]
    var expectedDecimalValue: Decimal
}
