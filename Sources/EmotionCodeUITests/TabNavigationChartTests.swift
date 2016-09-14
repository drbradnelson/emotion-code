import XCTest

// MARK: Main

final class TabNavigationChartTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabNavigationChartTests {

    func testChartSelection() {
        app.buttons["Chart"].tap()
        XCTAssert(app.buttons["Chart"].isSelected)
    }

    func testChartTitle() {
        app.buttons["Chart"].tap()
        XCTAssert(app.navigationBars["Chart"].exists)
    }

    func testChartDeselection() {
        app.buttons["Chart"].tap()
        XCTAssertFalse(app.buttons["Book"].isSelected)
        XCTAssertFalse(app.buttons["Help"].isSelected)
    }

}
