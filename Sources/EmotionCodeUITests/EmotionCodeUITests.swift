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

// MARK: Test layout

extension TabBarTests {

    func testHasThreeTabs() {
        XCTAssertEqual(app.tabBars.buttons.count, 3)
    }

    func testHasBookTab() {
        XCTAssertEqual(app.tabBars.buttons.elementBoundByIndex(0).label, "Book")
    }

    func testHasChartTab() {
        XCTAssertEqual(app.tabBars.buttons.elementBoundByIndex(1).label, "Chart")
    }

    func testHasHelpTab() {
        XCTAssertEqual(app.tabBars.buttons.elementBoundByIndex(2).label, "Help")
    }

}

// MARK: Test defaults

extension TabBarTests {

    func testDefaultSelection() {
        XCTAssert(app.buttons["Book"].selected)
    }

    func testDefaultTitle() {
        XCTAssert(app.navigationBars["Book"].exists)
    }

}

// MARK: Test book selection

extension TabBarTests {

    func testBookSelection() {
        app.buttons["Book"].tap()
        XCTAssert(app.buttons["Book"].selected)
    }

    func testBookTitle() {
        app.buttons["Book"].tap()
        XCTAssert(app.navigationBars["Book"].exists)
    }

    func testBookDeselection() {
        app.buttons["Book"].tap()
        XCTAssertFalse(app.buttons["Chart"].selected)
        XCTAssertFalse(app.buttons["Help"].selected)
    }

}

// MARK: Test chart selection

extension TabBarTests {

    func testChartSelection() {
        app.buttons["Chart"].tap()
        XCTAssert(app.buttons["Chart"].selected)
    }

    func testChartTitle() {
        app.buttons["Chart"].tap()
        XCTAssert(app.navigationBars["Chart"].exists)
    }

    func testChartDeselection() {
        app.buttons["Chart"].tap()
        XCTAssertFalse(app.buttons["Book"].selected)
        XCTAssertFalse(app.buttons["Help"].selected)
    }

}

// MARK: Test help selection

extension TabBarTests {

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

// MARK: App shortcut

private extension TabBarTests {

    var app: XCUIApplication {
        return XCUIApplication()
    }

}
