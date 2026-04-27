@testable import CalculatorUI
import Testing

struct CalculatorEngineTests {
    @Test(arguments: [
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            role: .number(1),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            role: .number(2),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(2))],
                expression: "2"
            )
        ),
        .init(
            role: .number(3),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(3))],
                expression: "3"
            )
        ),
        .init(
            role: .number(4),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(4))],
                expression: "4"
            )
        ),
        .init(
            role: .number(5),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(5))],
                expression: "5"
            )
        ),
        .init(
            role: .number(6),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(6))],
                expression: "6"
            )
        ),
        .init(
            role: .number(7),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(7))],
                expression: "7"
            )
        ),
        .init(
            role: .number(8),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(8))],
                expression: "8"
            )
        ),
        .init(
            role: .number(9),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(9))],
                expression: "9"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_number_when_empty(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),

    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_operator_when_empty(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test @MainActor
    func onTap_adding_period_when_empty() {
        let sut = CalculatorEngine()
        sut.onTap(.period)
        #expect(sut.isClear)
        #expect(sut.requests == [.term(.init(digits: [.number(0), .period]))])
        #expect(sut.expression == "0.")
    }

    @Test(arguments: [
        .init(
            role: .number(1),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(0)]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            role: .number(1),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(0), .period]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1)]))],
                expression: "0.1"
            )
        ),
        .init(
            role: .number(2),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1)]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(0), .period, .number(1), .number(2)]))],
                expression: "0.12"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_number_after_term(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(2))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(2), .period]))],
                expression: "2."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(3))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(3), .period]))],
                expression: "3."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(4))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(4), .period]))],
                expression: "4."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(5))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(5), .period]))],
                expression: "5."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(6))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(6), .period]))],
                expression: "6."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(7))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(7), .period]))],
                expression: "7."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(8))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(8), .period]))],
                expression: "8."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(9))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(9), .period]))],
                expression: "9."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: true,
                requests: [.term(.init(1.1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1.1))],
                expression: "1.1"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_period_after_number(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .period,
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.addition), .term(.init(digits: [.number(0), .period]))],
                expression: "+0."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.subtraction), .term(.init(digits: [.number(0), .period]))],
                expression: "-0."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.multiplication), .term(.init(digits: [.number(0), .period]))],
                expression: "×0."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.division), .term(.init(digits: [.number(0), .period]))],
                expression: "÷0."
            )
        ),
        .init(
            role: .period,
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.modulus), .term(.init(digits: [.number(0), .period]))],
                expression: "%0."
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_period_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.addition)],
                expression: "1+"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.subtraction)],
                expression: "1-"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.multiplication)],
                expression: "1×"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.division)],
                expression: "1÷"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.modulus)],
                expression: "1%"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_operator_after_term(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.addition)],
                expression: "+"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_addition_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
        .init(
            role: .operator(.addition),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)],
                expression: "0+"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_addition_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.multiplication), .operator(.subtraction)],
                expression: "×-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.division), .operator(.subtraction)],
                expression: "÷-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.modulus), .operator(.subtraction)],
                expression: "%-"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_subtraction_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)],
                expression: "0-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)],
                expression: "0-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
                expression: "0×-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
                expression: "0÷-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
                expression: "0%-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)],
                expression: "0×-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)],
                expression: "0÷-"
            )
        ),
        .init(
            role: .operator(.subtraction),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)],
                expression: "0%-"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_subtraction_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.multiplication)],
                expression: "×"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_multiplication_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
        .init(
            role: .operator(.multiplication),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)],
                expression: "0×"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_multiplication_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.division)],
                expression: "÷"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_division_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
        .init(
            role: .operator(.division),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)],
                expression: "0÷"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_division_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.modulus)],
                expression: "%"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_modulus_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
        .init(
            role: .operator(.modulus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)],
                expression: "0%"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_modulus_after_term_and_operators(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: [.operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.addition), .term(.init(0))],
                expression: "+0"
            )
        ),
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.subtraction), .term(.init(0))],
                expression: "-0"
            )
        ),
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: [.operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.multiplication), .term(.init(0))],
                expression: "×0"
            )
        ),
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: [.operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.division), .term(.init(0))],
                expression: "÷0"
            )
        ),
        .init(
            role: .number(0),
            premise: .init(
                isClear: false,
                requests: [.operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.modulus), .term(.init(0))],
                expression: "%0"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_adding_number_after_operator(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1))],
                expression: "1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.subtraction), .term(.init(1))],
                expression: "-1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.addition), .term(.init(0))],
                expression: "1+0"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.addition), .term(.init(0))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(1)), .operator(.subtraction), .term(.init(0))],
                expression: "1-0"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.multiplication), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))],
                expression: "×-1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.multiplication), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.multiplication), .term(.init(1))],
                expression: "×1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.division), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.division), .operator(.subtraction), .term(.init(1))],
                expression: "÷-1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.division), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.division), .term(.init(1))],
                expression: "÷1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.modulus), .term(.init(1))],
                expression: "%1"
            )
        ),
        .init(
            role: .command(.plusMinus),
            premise: .init(
                isClear: true,
                requests: [.operator(.modulus), .term(.init(1))]
            ),
            expect: .init(
                isClear: true,
                requests: [.operator(.modulus), .operator(.subtraction), .term(.init(1))],
                expression: "%-1"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_plus_minus(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test @MainActor
    func onTap_calculate_skipped() {
        let sut = CalculatorEngine()
        sut.isClear = true
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)]
        sut.onTap(.command(.calculate))
        #expect(sut.isClear)
        #expect(sut.requests == [.term(.init(1)), .operator(.multiplication), .operator(.subtraction)])
    }

    @Test @MainActor
    func onTap_calculate_succeeded() {
        let sut = CalculatorEngine()
        sut.isClear = true
        sut.requests = [.term(.init(1)), .operator(.multiplication), .operator(.subtraction), .term(.init(1))]
        sut.onTap(.command(.calculate))
        #expect(!sut.isClear)
        #expect(sut.requests == [.operator(.subtraction), .term(.init(1))])
        #expect(sut.expression == "-1")
    }

    @Test(arguments: [.division, .modulus] as [Operator])
    @MainActor
    func onTap_calculate_failed(_ o: Operator) {
        let sut = CalculatorEngine()
        sut.isClear = true
        sut.requests = [.term(.init(1)), .operator(o), .term(.init(0))]
        sut.onTap(.command(.calculate))
        #expect(!sut.isClear)
        #expect(sut.requests.isEmpty)
        #expect(sut.error == .undefined)
    }

    @Test @MainActor
    func onTap_allClear() {
        let sut = CalculatorEngine()
        sut.isClear = true
        sut.requests = [.term(.init(1)), .operator(.addition), .term(.init(1))]
        sut.onTap(.command(.clear))
        sut.onTap(.command(.allClear))
        #expect(!sut.isClear)
        #expect(sut.requests.isEmpty)
        #expect(sut.expression == "0")
    }

    @Test @MainActor
    func onTap_allClear_undefined() {
        let sut = CalculatorEngine()
        sut.error = .undefined
        sut.onTap(.command(.allClear))
        #expect(sut.error == nil)
        #expect(sut.expression == "0")
    }

    @Test(arguments: [
        .init(
            role: .command(.clear),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0))]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .command(.clear),
            premise: .init(
                isClear: true,
                requests: [.operator(.subtraction), .term(.init(1))]
            ),
            expect: .init(
                isClear: false,
                requests: [.operator(.subtraction)],
                expression: "-"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_clear(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }

    @Test(arguments: [
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: false,
                requests: []
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1)]))]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .number(2)]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1)]))],
                expression: "1"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1)]))],
                expression: "1"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)]))]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period])), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period]))],
                expression: "1."
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)])), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(digits: [.number(1), .period, .number(2)]))],
                expression: "1.2"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.addition)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: false,
                requests: [.operator(.subtraction)]
            ),
            expect: .init(
                isClear: false,
                requests: [],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.subtraction)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.multiplication)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.division)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
        .init(
            role: .command(.delete),
            premise: .init(
                isClear: true,
                requests: [.term(.init(0)), .operator(.modulus)]
            ),
            expect: .init(
                isClear: true,
                requests: [.term(.init(0))],
                expression: "0"
            )
        ),
    ] as [OnTapCondition])
    @MainActor
    func onTap_delete(_ condition: OnTapCondition) {
        let sut = CalculatorEngine()
        sut.isClear = condition.premise.isClear
        sut.requests = condition.premise.requests
        sut.onTap(condition.role)
        #expect(sut.isClear == condition.expect.isClear)
        #expect(sut.requests == condition.expect.requests)
        #expect(sut.expression == condition.expect.expression)
    }
}

struct OnTapCondition: Sendable {
    var role: Role
    var premise: Premise
    var expect: Expect

    struct Premise: Sendable {
        var isClear: Bool
        var requests: [Request]
    }

    struct Expect: Sendable {
        var isClear: Bool
        var requests: [Request]
        var expression: String
    }
}
