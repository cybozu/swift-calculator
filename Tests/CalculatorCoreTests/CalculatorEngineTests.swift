@testable import CalculatorCore
import Testing

struct CalculatorEngineTests {
    @Test(arguments: [
        .init(
            number: 0,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            number: 1,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            number: 2,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(2))],
                expression: "2"
            )
        ),
        .init(
            number: 3,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(3))],
                expression: "3"
            )
        ),
        .init(
            number: 4,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(4))],
                expression: "4"
            )
        ),
        .init(
            number: 5,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(5))],
                expression: "5"
            )
        ),
        .init(
            number: 6,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(6))],
                expression: "6"
            )
        ),
        .init(
            number: 7,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(7))],
                expression: "7"
            )
        ),
        .init(
            number: 8,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(8))],
                expression: "8"
            )
        ),
        .init(
            number: 9,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(9))],
                expression: "9"
            )
        ),
    ] as [NumberCondition])
    func handle_number_when_empty(_ condition: NumberCondition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(number: condition.number)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            operator: .addition,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            operator: .subtraction,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            operator: .multiplication,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            operator: .division,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            operator: .modulus,
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),

    ] as [OperatorCondition])
    func handle_operator_when_empty(_ condition: OperatorCondition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: condition.operator)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test
    func handle_period_when_empty() {
        var sut = CalculatorEngine()
        sut.handlePeriod()
        #expect(sut.isEditingTerm)
        #expect(sut.requests == [.term(.init(digits: [.number(0), .period]))])
        #expect(sut.expression == "0.")
    }

    @Test(arguments: [
        .init(
            number: 1,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(0)]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            number: 1,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(0), .period]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1)]))],
                expression: "0.1"
            )
        ),
        .init(
            number: 2,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1)]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1), .number(2)]))],
                expression: "0.12"
            )
        ),
    ] as [NumberCondition])
    func handle_number_after_term(_ condition: NumberCondition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(number: condition.number)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(2))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(2), .period]))],
                expression: "2."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(3))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(3), .period]))],
                expression: "3."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(4))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(4), .period]))],
                expression: "4."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(5))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(5), .period]))],
                expression: "5."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(6))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(6), .period]))],
                expression: "6."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(7))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(7), .period]))],
                expression: "7."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(8))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(8), .period]))],
                expression: "8."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(9))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(9), .period]))],
                expression: "9."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1.1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1.1))],
                expression: "1.1"
            )
        ),
    ] as [Condition])
    func handle_period_after_number(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handlePeriod()
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.addition), .term(.init(digits: [.number(0), .period]))],
                expression: "+0."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.subtraction), .term(.init(digits: [.number(0), .period]))],
                expression: "-0."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .term(.init(digits: [.number(0), .period]))],
                expression: "×0."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .term(.init(digits: [.number(0), .period]))],
                expression: "÷0."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .term(.init(digits: [.number(0), .period]))],
                expression: "%0."
            )
        ),
    ] as [Condition])
    func handle_period_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handlePeriod()
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            operator: .addition,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.addition)],
                expression: "1+"
            )
        ),
        .init(
            operator: .subtraction,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.subtraction)],
                expression: "1-"
            )
        ),
        .init(
            operator: .multiplication,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.multiplication)],
                expression: "1×"
            )
        ),
        .init(
            operator: .division,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.division)],
                expression: "1÷"
            )
        ),
        .init(
            operator: .modulus,
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.modulus)],
                expression: "1%"
            )
        ),
    ] as [OperatorCondition])
    func handle_operator_input_operator_after_term(_ condition: OperatorCondition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: condition.operator)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
    ] as [Condition])
    func handle_operator_input_addition_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .addition)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
    ] as [Condition])
    func handle_operator_input_addition_after_term_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .addition)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication), .operator(.subtraction)],
                expression: "×-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.division), .operator(.subtraction)],
                expression: "÷-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus), .operator(.subtraction)],
                expression: "%-"
            )
        ),
    ] as [Condition])
    func handle_operator_input_subtraction_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .subtraction)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)],
                expression: "0-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)],
                expression: "0-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
                expression: "0×-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
                expression: "0÷-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
                expression: "0%-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
                expression: "0×-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
                expression: "0÷-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
                expression: "0%-"
            )
        ),
    ] as [Condition])
    func handle_operator_input_subtraction_after_term_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .subtraction)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
    ] as [Condition])
    func handle_operator_input_multiplication_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .multiplication)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
    ] as [Condition])
    func handle_operator_input_multiplication_after_term_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .multiplication)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
    ] as [Condition])
    func handle_operator_input_division_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .division)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
    ] as [Condition])
    func handle_operator_input_division_after_term_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .division)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
    ] as [Condition])
    func handle_operator_input_modulus_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .modulus)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
    ] as [Condition])
    func handle_operator_input_modulus_after_term_and_operators(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(operator: .modulus)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.addition), .term(.init(0))],
                expression: "+0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.subtraction), .term(.init(0))],
                expression: "-0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .term(.init(0))],
                expression: "×0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .term(.init(0))],
                expression: "÷0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .term(.init(0))],
                expression: "%0"
            )
        ),
    ] as [Condition])
    func handle_number_after_operator(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handle(number: 0)
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.subtraction), .term(.init(1))],
                expression: "-1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.addition), .term(.init(0))],
                expression: "1+0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.addition), .term(.init(0))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))],
                expression: "1-0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))],
                expression: "×-1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.multiplication), .term(.init(1))],
                expression: "×1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .operator(.subtraction), .term(.init(1))],
                expression: "÷-1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.division), .term(.init(1))],
                expression: "÷1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .term(.init(1))],
                expression: "%1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))],
                expression: "%-1"
            )
        ),
    ] as [Condition])
    func handle_plus_minus(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handlePlusMinus()
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test
    func handle_calculate_skipped() {
        var sut = CalculatorEngine()
        sut.isEditingTerm = true
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)]
        sut.handleCalculate()
        #expect(sut.isEditingTerm)
        #expect(sut.requests == [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)])
    }

    @Test
    func handle_calculate_succeeded() {
        var sut = CalculatorEngine()
        sut.isEditingTerm = true
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction), .term(.init(1))]
        sut.handleCalculate()
        #expect(!sut.isEditingTerm)
        #expect(sut.requests == [.operator(.subtraction), .term(.init(1))])
        #expect(sut.expression == "-1")
    }

    @Test(arguments: [.division, .modulus] as [Operator])
    func handle_calculate_failed(_ o: Operator) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = true
        sut.requests = [.term(.init(1)), .operator(o), .term(.init(0))]
        sut.handleCalculate()
        #expect(!sut.isEditingTerm)
        #expect(sut.requests.isEmpty)
        #expect(sut.error == .undefined)
    }

    @Test
    func handle_all_clear() {
        var sut = CalculatorEngine()
        sut.isEditingTerm = true
        sut.requests = [.term(.init(1)), .operator(.addition), .term(.init(1))]
        sut.handleClear()
        sut.handleAllClear()
        #expect(!sut.isEditingTerm)
        #expect(sut.requests.isEmpty)
        #expect(sut.expression == "0")
    }

    @Test
    func handle_all_clear_undefined() {
        var sut = CalculatorEngine()
        sut.error = .undefined
        sut.handleAllClear()
        #expect(sut.error == nil)
        #expect(sut.expression == "0")
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
    ] as [Condition])
    func handle_clear(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handleClear()
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: []
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1)]))]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .number(2)]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1)]))],
                expression: "1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1)]))],
                expression: "1"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)]))]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period])), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)])), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)]))],
                expression: "1.2"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            premise: .init(
                isEditingTerm: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isEditingTerm: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
    ] as [Condition])
    func handle_delete(_ condition: Condition) {
        var sut = CalculatorEngine()
        sut.isEditingTerm = condition.premise.isEditingTerm
        sut.requests = condition.premise.requests
        sut.handleDelete()
        #expect(sut.isEditingTerm == condition.expect.isEditingTerm)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }
}

struct Premise: Sendable {
    var isEditingTerm: Bool
    var requests: [Request]
}

struct Expect: Sendable {
    var isEditingTerm: Bool
    var requests: [Request]
    var expression: String
}

struct Condition: Sendable {
    var premise: Premise
    var expect: Expect
}

struct NumberCondition: Sendable {
    var number: Int
    var premise: Premise
    var expect: Expect
}

struct OperatorCondition: Sendable {
    var `operator`: Operator
    var premise: Premise
    var expect: Expect
}
