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

    func testLeftBarButtonActionOnFirtsChapter() {
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        XCUIApplication().navigationBars["Book"].buttons["〈"].tap()
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testLeftBarButtonAction() {
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        XCUIApplication().navigationBars["Book"].buttons["〉"].tap()
        XCUIApplication().navigationBars["Book"].buttons["〈"].tap()
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testRightBarButton() {
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        XCUIApplication().navigationBars["Book"].buttons["〉"].tap()
        XCTAssert(XCUIApplication().navigationBars["Book"].buttons["Chapter 2 ▽"].hittable)
    }

}
