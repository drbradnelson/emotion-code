import XCTest

final class BookNavigationBarLayoutTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testChapterButton() {
        XCTAssert(app.navigationBars.first.buttons["Chapter 1"].isHittable)
    }

    func testPreviousChapterButton() {
        XCTAssert(app.navigationBars.first.buttons["Previous Chapter"].isHittable)
    }

    func testNextChapterButton() {
        XCTAssert(app.navigationBars.first.buttons["Next Chapter"].isHittable)
    }

}
