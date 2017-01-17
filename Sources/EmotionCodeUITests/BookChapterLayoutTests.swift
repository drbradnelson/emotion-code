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
            return staticText.label.hasPrefix("Prehendit posse")
        }
        let beginningText = app.staticTexts.matching(beginningPredicate).element
        let topLayoutGuide = app.navigationBars.element.frame.maxY
        let topMargin: CGFloat = 18
        XCTAssertEqual(beginningText.frame.minY, topLayoutGuide + topMargin)
    }

    func testTopLayoutGuideForChapter2() {
        app.buttons["Next Chapter"].tap()
        let beginningPredicate = NSPredicate { staticText, _ -> Bool in
            guard let staticText = staticText as? XCUIElementAttributes else { return false }
            return staticText.label.hasPrefix("Spumantiaque voce te frequentat qua ille deas")
        }
        let beginningText = app.staticTexts.matching(beginningPredicate).element
        let topLayoutGuide = app.navigationBars.element.frame.maxY
        let topMargin: CGFloat = 18
        XCTAssertEqual(beginningText.frame.minY, topLayoutGuide + topMargin)
    }

}
