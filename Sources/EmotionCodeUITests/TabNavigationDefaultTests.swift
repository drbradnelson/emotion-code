import XCTest

final class TabNavigationDefaultTests: XCTestCase {

    // MARK: Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

    // MARK: Tests

    func testDefaultSelection() {
        XCTAssert(app.buttons["Book"].isSelected)
    }

    func testDefaultTitle() {
        XCTAssert(app.navigationBars.first.exists)
    }

}
