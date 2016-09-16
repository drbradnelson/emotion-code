import XCTest

final class BookChapterSelectionLayoutTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chapter 1"].tap()
    }

    // MARK: Tests

    func testCancelButton() {
        XCTAssert(app.navigationBars["Table of Contents"].buttons["Cancel"].isHittable)
    }

}
