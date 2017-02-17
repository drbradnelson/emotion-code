import XCTest

final class EmotionCodeUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func testTapBookTab1() {
        app.tabBars.buttons["Book"].tap()
    }

    func testTapChartTab2() {
        app.tabBars.buttons["Chart"].tap()
    }

    func testTapSupportTab3() {
        app.tabBars.buttons["Support"].tap()
    }

}
