import XCTest

// MARK: Main

final class TabNavigationDefaultTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension TabNavigationDefaultTests {

    func testDefaultSelection() {
        XCTAssert(app.buttons["Book"].isSelected)
    }

    func testDefaultTitle() {
        XCTAssert(app.navigationBars.first.exists)
    }

}
