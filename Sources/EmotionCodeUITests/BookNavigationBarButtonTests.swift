import XCTest

final class BookNavigationBarButtonTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testPreviousChapterButtonStates() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasPreviousChapter = chapterIndex > expectedChapterIndices.first!
            XCTAssertEqual(app.buttons["Previous Chapter"].isEnabled, hasPreviousChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testNextChapterButtonStates() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasNextChapter = chapterIndex < expectedChapterIndices.last!
            XCTAssertEqual(app.buttons["Next Chapter"].isEnabled, hasNextChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testChapterTitleButton() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            XCTAssert(app.buttons["Chapter \(chapterIndex + 1)"].isHittable)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testPreviousChapterButtonStateAfterFirstChapterSelection() {
        app.buttons["Chapter 1"].tap()
        let firstChapterCell = app.cells.first
        firstChapterCell.tap()
        XCTAssertFalse(app.buttons["Previous Chapter"].isEnabled)
    }

    func testNextChapterButtonStateAfterLastChapterSelection() {
        app.buttons["Chapter 1"].tap()
        let lastChapterCell = app.cells.last
        lastChapterCell.tap()
        XCTAssertFalse(app.buttons["Next Chapter"].isEnabled)
    }
    
}
