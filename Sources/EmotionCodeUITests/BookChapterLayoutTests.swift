import XCTest

// MARK: Main

final class BookChapterLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension BookChapterLayoutTests {

    func testTopLayoutGuide() {
        let beginningPredicate = NSPredicate { staticText, _ -> Bool in
            guard let staticText = staticText as? XCUIElementAttributes else { return false }
            return staticText.label.hasPrefix("Truth is stranger than fiction")
        }
        let beginningText = app.staticTexts.matchingPredicate(beginningPredicate).element
        let topLayoutGuide = app.navigationBars.element.frame.maxY
        let topMargin: CGFloat = 10
        XCTAssertEqual(beginningText.frame.minY, topLayoutGuide + topMargin)
    }

}
