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
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1))],
            expectedString: "2"
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1)), .operator(.equal)],
            expectedString: "2"
        ),
        // 1+1=+1=+1= -> ((1+1)+1)+1 -> 4
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedString: "4"
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction), .operand(.init(3))],
            expectedString: "-2"
        ),
        // A settled single value is formatted as is.
        .init(
            tokens: [.operand(.init(3))],
            expectedString: "3"
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(2))],
            expectedString: "-2"
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.addition)],
            expectedString: CalculationError.invalidFormula.localizedDescription
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.division), .operand(.init(0))],
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
            tokens: [.operand(.init(1)), .operator(.addition)],
            expectedString: "1+"
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(1.2))],
            expectedString: "-1.2"
        ),
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedString: "1+1=+1="
        ),
    ] as [StringCondition])
    func expression_from_tokens(_ condition: StringCondition) {
        let actual = CalculatorFormatter().expression(from: condition.tokens)
        #expect(actual == condition.expectedString)
    }

    @Test(arguments: [
        .init(
            tokens: [.operand(.init(1)), .operator(.addition), .operand(.init(1)), .operator(.equal)],
            expectedDecimalValue: 2
        ),
        .init(
            tokens: [
                .operand(.init(1)),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal),
                .operator(.addition),
                .operand(.init(1)),
                .operator(.equal)
            ],
            expectedDecimalValue: 3
        ),
        .init(
            tokens: [.operand(.init(1)), .operator(.subtraction), .operand(.init(3)), .operator(.equal)],
            expectedDecimalValue: -2
        ),
        .init(
            tokens: [.operand(.init(0.1)), .operator(.addition), .operand(.init(0.2))],
            expectedDecimalValue: 0.3
        ),
        // A settled single value is returned as is.
        .init(
            tokens: [.operand(.init(3))],
            expectedDecimalValue: 3
        ),
        .init(
            tokens: [.operator(.subtraction), .operand(.init(2))],
            expectedDecimalValue: -2
        ),
    ] as [DecimalValueCondition])
    func calculatedDecimalValue(_ condition: DecimalValueCondition) throws {
        let actual = try condition.tokens.calculatedDecimalValue()
        #expect(actual == condition.expectedDecimalValue)
    }

    @Test
    func calculatedDecimalValue_error() {
        #expect(throws: CalculationError.invalidFormula) {
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
