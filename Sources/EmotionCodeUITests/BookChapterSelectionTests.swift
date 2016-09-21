import XCTest

final class BookChapterSelectionTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testCancelButtonAction() {
        app.buttons["Chapter 1"].tap()
        app.buttons["Cancel"].tap()
        XCTAssert(app.buttons["Chapter 1"].isHittable)
    }

    func testChapterCellSelection() {
        app.mainWindow.swipeLeft()
        app.buttons["Chapter 2"].tap()
        XCTAssert(app.cells.element(boundBy: 1).isSelected)
    }

    func testChapterSelection() {
        app.buttons["Chapter 1"].tap()
        app.cells.element(boundBy: 3).tap()
        XCTAssert(app.buttons["Chapter 4"].isHittable)
    }

}
