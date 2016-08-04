import XCTest

// MARK: Main

final class TabNavigationHelpTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabNavigationHelpTests {

    func testHelpSelection() {
        app.buttons["Help"].tap()
        XCTAssert(app.buttons["Help"].selected)
    }

    func testHelpTitle() {
        app.buttons["Help"].tap()
        XCTAssert(app.navigationBars["Help"].exists)
    }

    func testHelpDeselection() {
        app.buttons["Help"].tap()
        XCTAssertFalse(app.buttons["Book"].selected)
        XCTAssertFalse(app.buttons["Chart"].selected)
    }

}
