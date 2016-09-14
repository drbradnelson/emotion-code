import XCTest

// MARK: Main

final class TabNavigationLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabNavigationLayoutTests {

    func testHasThreeTabs() {
        XCTAssertEqual(app.tabBars.buttons.count, 3)
    }

    func testHasBookTab() {
        XCTAssertEqual(app.tabBars.buttons.element(boundBy: 0).label, "Book")
    }

    func testHasChartTab() {
        XCTAssertEqual(app.tabBars.buttons.element(boundBy: 1).label, "Chart")
    }

    func testHasHelpTab() {
        XCTAssertEqual(app.tabBars.buttons.element(boundBy: 2).label, "Help")
    }

}
