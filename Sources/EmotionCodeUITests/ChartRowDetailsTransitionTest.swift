import XCTest

// MARK: Main

final class ChartRowDetailsTransitionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chart"].tap()
    }
}

// MARK: Tests

extension ChartRowDetailsTransitionTest {

    func testChartRowDetailsTransition() {

        let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        rowCellElement.element.tap()

        sleep(1)

        let backButton = app.navigationBars.buttons.first
        backButton.tap()

        sleep(1)

        let chartView = app.collectionViews.matchingIdentifier("ChartOverviewView")

        XCTAssertEqual(chartView.count, 1)
    }
}
