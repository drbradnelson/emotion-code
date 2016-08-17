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
        app.buttons["Previous Chapter"].tap()
        XCTAssert(app.buttons["Chapter 1"].hittable)
    }

    func testLeftBarButtonAction() {
        app.buttons["Next Chapter"].tap()
        app.buttons["Previous Chapter"].tap()
        XCTAssert(app.buttons["Chapter 1"].hittable)
    }

    func testRightBarButtonAction() {
        app.buttons["Next Chapter"].tap()
        XCTAssert(app.buttons["Chapter 2"].hittable)
    }

}
