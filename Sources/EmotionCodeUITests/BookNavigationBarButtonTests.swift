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
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        app.navigationBars["Book"].buttons["〈"].tap()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testLeftBarButtonAction() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        app.navigationBars["Book"].buttons["〉"].tap()
        app.navigationBars["Book"].buttons["〈"].tap()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testRightBarButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        app.navigationBars["Book"].buttons["〉"].tap()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 2 ▽"].hittable)
    }

}
