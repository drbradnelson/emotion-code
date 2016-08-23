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
        app.mainWindow.swipeRight()
        XCTAssert(app.buttons["Chapter 1"].hittable)
    }

    func testRightSwipe() {
        app.mainWindow.swipeLeft()
        app.mainWindow.swipeRight()
        XCTAssert(app.buttons["Chapter 1"].hittable)
    }

    func testLeftBarButton() {
        app.mainWindow.swipeLeft()
        XCTAssert(app.buttons["Chapter 2"].hittable)
    }

}
