import XCTest

// MARK: Main

final class ChartRowDetailsLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chart"].tap()
    }
}

// MARK: Tests

extension ChartRowDetailsLayoutTests {

    func testRowCounterIsAlignedVertically() {

        let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        rowCellElement.element.tap()

        sleep(2)

        let rowCounterElementTop = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0")
        let rowCounterElementBottom = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_1")

        let leftAligned = rowCounterElementTop.element.frame.minX == rowCounterElementBottom.element.frame.minX
        let rightAligned = rowCounterElementTop.element.frame.maxX == rowCounterElementBottom.element.frame.maxX

        XCTAssertEqual(leftAligned && rightAligned, true)
    }
}
