import XCTest

// MARK: Main

final class TabBarTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabBarTests {

    func testAvailableTabs() {
        let elements = app.tabBars.buttons.allElementsBoundByIndex
        let labels = elements.map { $0.label }
        XCTAssertEqual(labels, ["Book", "Chart", "Help"])
    }

    func testDefaultTab() {
        XCTAssert(app.navigationBars["Book"].exists)
        XCTAssert(app.buttons["Book"].selected)
    }

    func testSwitchingTabs() {
        let labels = ["Chart", "Help", "Book"]
        labels.forEach { label in
            app.buttons[label].tap()
            XCTAssert(app.buttons[label].selected)
            XCTAssert(app.navigationBars[label].exists)
        }
    }

}

// MARK: App shortcut

private extension TabBarTests {

    var app: XCUIApplication {
        return XCUIApplication()
    }

}
