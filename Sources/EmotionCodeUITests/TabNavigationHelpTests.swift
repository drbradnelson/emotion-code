import XCTest

final class TabNavigationHelpTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testHelpSelection() {
        app.buttons["Help"].tap()
        XCTAssert(app.buttons["Help"].isSelected)
    }

    func testHelpTitle() {
        app.buttons["Help"].tap()
        XCTAssert(app.navigationBars["Help"].exists)
    }

    func testHelpDeselection() {
        app.buttons["Help"].tap()
        XCTAssertFalse(app.buttons["Book"].isSelected)
        XCTAssertFalse(app.buttons["Chart"].isSelected)
    }

}
