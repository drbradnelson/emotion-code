import XCTest

final class BookSwipeGesturesTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testRightSwipeOnFirtsChapter() {
        app.mainWindow.swipeRight()
        XCTAssert(app.buttons["Chapter 1"].isHittable)
    }

    func testRightSwipe() {
        app.mainWindow.swipeLeft()
        app.mainWindow.swipeRight()
        XCTAssert(app.buttons["Chapter 1"].isHittable)
    }

    func testLeftBarButton() {
        app.mainWindow.swipeLeft()
        XCTAssert(app.buttons["Chapter 2"].isHittable)
    }
    
}
