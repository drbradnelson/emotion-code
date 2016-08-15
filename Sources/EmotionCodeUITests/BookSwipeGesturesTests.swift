import XCTest

// MARK: Main

final class BookSwipeGesturesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension BookSwipeGesturesTests {

    func testRightSwipeOnFirtsChapter() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
        app.mainWindow.swipeRight()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
    }

    func testRightSwipe() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
        app.mainWindow.swipeLeft()
        app.mainWindow.swipeRight()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
    }

    func testLeftBarButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
        app.mainWindow.swipeLeft()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 2"].hittable)
    }

}
