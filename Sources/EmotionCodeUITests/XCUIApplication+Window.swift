import XCTest

extension XCUIApplication {

    var mainWindow: XCUIElement {
        return windows.element(boundBy: 0)
    }

}
