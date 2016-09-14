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
        XCTAssert(app.navigationBars.first.buttons["Chapter 1"].isHittable)
    }

    func testPreviousChapterButton() {
        XCTAssert(app.navigationBars.first.buttons["Previous Chapter"].isHittable)
    }

    func testNextChapterButton() {
        XCTAssert(app.navigationBars.first.buttons["Next Chapter"].isHittable)
    }

}
