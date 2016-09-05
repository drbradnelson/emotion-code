import XCTest

// MARK: Main

final class ChartOverviewTransitionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chart"].tap()
    }
}

// MARK: Tests

extension ChartOverviewTransitionTest {

    func testChartOverviewTransition() {

        let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        rowCellElement.element.tap()

        sleep(1)

        let chartRowDetailsView = app.collectionViews.matchingIdentifier("ChartRowDetailsView")

        XCTAssertEqual(chartRowDetailsView.count, 1)
    }
}
