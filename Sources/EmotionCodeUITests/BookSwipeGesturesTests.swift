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
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        app.swipeRight()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testRightSwipe() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        app.swipeLeft()
        app.swipeRight()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
    }

    func testLeftBarButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1 ▽"].hittable)
        print(app.webViews.elementBoundByIndex(0))
        XCTAssert(app.webViews.elementBoundByIndex(0).exists)
        app.webViews.elementBoundByIndex(0).swipeLeft()
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 2 ▽"].hittable)
    }

}
