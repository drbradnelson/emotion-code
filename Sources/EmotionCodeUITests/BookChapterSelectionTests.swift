import XCTest

// MARK: Main

final class BookChapterSelectionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension BookChapterSelectionTests {

    func testCancelButtonAction() {
        app.buttons["Chapter 1"].tap()
        app.buttons["Cancel"].tap()
        XCTAssert(app.buttons["Chapter 1"].hittable)
    }

    func testChapterCellSelection() {
        app.mainWindow.swipeLeft()
        app.buttons["Chapter 2"].tap()
        XCTAssert(app.cells.elementBoundByIndex(1).selected)
    }

    func testChapterSelection() {
        app.buttons["Chapter 1"].tap()
        app.cells.elementBoundByIndex(3).tap()
        XCTAssert(app.buttons["Chapter 4"].hittable)
    }

}
