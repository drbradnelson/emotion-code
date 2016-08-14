import XCTest

// MARK: Main

final class BookNavigationBarButtonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension BookNavigationBarButtonTests {

    func testLeftBarButton() {
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["〈"].hittable)
    }

    func testRightBarButton() {
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["〉"].hittable)
    }

}
