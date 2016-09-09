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

    func testPreviousChapterButtonStates() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasPreviousChapter = chapterIndex > expectedChapterIndices.first
            XCTAssertEqual(app.buttons["Previous Chapter"].enabled, hasPreviousChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testNextChapterButtonStates() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasNextChapter = chapterIndex < expectedChapterIndices.last
            XCTAssertEqual(app.buttons["Next Chapter"].enabled, hasNextChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testChapterTitleButton() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            XCTAssert(app.buttons["Chapter \(chapterIndex + 1)"].hittable)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testPreviousChapterButtonStateAfterFirstChapterSelection() {
        app.buttons["Chapter 1"].tap()
        let firstChapterCell = app.cells.first
        firstChapterCell.tap()
        XCTAssertFalse(app.buttons["Previous Chapter"].enabled)
    }

    func testNextChapterButtonStateAfterLastChapterSelection() {
        app.buttons["Chapter 1"].tap()
        let lastChapterCell = app.cells.last
        lastChapterCell.tap()
        XCTAssertFalse(app.buttons["Next Chapter"].enabled)
    }

}
