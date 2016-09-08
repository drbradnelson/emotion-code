import XCTest

extension XCUIApplication {

    var mainWindow: XCUIElement {
        return windows.elementBoundByIndex(0)
    }

}
