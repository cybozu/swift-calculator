import XCTest

final class ExampleUITests: XCTestCase {
    @MainActor
    func testHappyPass() async throws {
        let app = XCUIApplication()
        app.launch()

        let calcPicker = app.otherElements["calculator"].wait(for: \.exists, toEqual: true)

        // 12.3 % 4 * 5 ± / 6 + 7 = close
        calcPicker.buttons["number1Button"].tap()
        calcPicker.buttons["number2Button"].tap()
        calcPicker.buttons["periodButton"].tap()
        calcPicker.buttons["number3Button"].tap()
        calcPicker.buttons["modulusButton"].tap()
        calcPicker.buttons["number4Button"].tap()
        calcPicker.buttons["multiplicationButton"].tap()
        calcPicker.buttons["number5Button"].tap()
        calcPicker.buttons["plusMinusButton"].tap()
        calcPicker.buttons["divisionButton"].tap()
        calcPicker.buttons["number6Button"].tap()
        calcPicker.buttons["additionButton"].tap()
        calcPicker.buttons["number7Button"].tap()
        calcPicker.buttons["equalButton"].tap()

        try await Task.sleep(for: .seconds(1.5))

        calcPicker.buttons["allClearButton"].tap()
    }
}
