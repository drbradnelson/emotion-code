import XCTest

final class BookChapterLayoutTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testTopLayoutGuideForChapter1() {
        let beginningPredicate = NSPredicate { staticText, _ -> Bool in
            guard let staticText = staticText as? XCUIElementAttributes else { return false }
            return staticText.label.hasPrefix("Truth is stranger than fiction")
        }
        let beginningText = app.staticTexts.matching(beginningPredicate).element
        let topLayoutGuide = app.navigationBars.element.frame.maxY
        let topMargin: CGFloat = 10
        XCTAssertEqual(beginningText.frame.minY, topLayoutGuide + topMargin)
    }


    func testTopLayoutGuideForChapter2() {
        app.buttons["Next Chapter"].tap()
        let beginningPredicate = NSPredicate { staticText, _ -> Bool in
            guard let staticText = staticText as? XCUIElementAttributes else { return false }
            return staticText.label.hasPrefix("The doctor of the future")
        }
        let beginningText = app.staticTexts.matching(beginningPredicate).element
        let topLayoutGuide = app.navigationBars.element.frame.maxY
        let topMargin: CGFloat = 10
        XCTAssertEqual(beginningText.frame.minY, topLayoutGuide + topMargin)
    }

}
