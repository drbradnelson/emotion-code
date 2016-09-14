import XCTest

// MARK: Main

final class TabNavigationBookTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabNavigationBookTests {

    func testBookSelection() {
        app.buttons["Book"].tap()
        XCTAssert(app.buttons["Book"].isSelected)
    }

    func testBookTitle() {
        app.buttons["Book"].tap()
        XCTAssert(app.navigationBars.first.exists)
    }

    func testBookDeselection() {
        app.buttons["Book"].tap()
        XCTAssertFalse(app.buttons["Chart"].isSelected)
        XCTAssertFalse(app.buttons["Help"].isSelected)
    }

}
