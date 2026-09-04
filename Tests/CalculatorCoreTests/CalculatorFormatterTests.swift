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
            expectedString: "1+1=+1="
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
