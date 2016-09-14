import XCTest

// MARK: Main

final class BookChapterSelectionLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chapter 1"].tap()
    }

}

// MARK: Tests

extension BookChapterSelectionLayoutTests {

    func testCancelButton() {
        XCTAssert(app.navigationBars["Table of Contents"].buttons["Cancel"].isHittable)
    }

}
