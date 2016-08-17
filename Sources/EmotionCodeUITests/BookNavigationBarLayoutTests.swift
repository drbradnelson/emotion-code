import XCTest

// MARK: Main

final class BookNavigationBarLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

extension BookNavigationBarLayoutTests {

    func testChapterButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Chapter 1"].hittable)
    }

    func testPreviousChapterButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Previous Chapter"].hittable)
    }

    func testNextChapterButton() {
        XCTAssert(app.navigationBars["Book"].buttons["Next Chapter"].hittable)
    }

}
