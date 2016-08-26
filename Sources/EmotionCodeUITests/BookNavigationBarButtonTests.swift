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

    func testLeftBarButtonAction() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasPreviousChapter = chapterIndex > expectedChapterIndices.first
            XCTAssertEqual(app.buttons["Previous Chapter"].enabled, hasPreviousChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

    func testRightBarButtonAction() {
        let expectedChapterIndices = Array(0...10)
        expectedChapterIndices.forEach { chapterIndex in
            let hasNextChapter = chapterIndex < expectedChapterIndices.last
            XCTAssertEqual(app.buttons["Next Chapter"].enabled, hasNextChapter)
            app.buttons["Next Chapter"].tap()
        }
    }

}
