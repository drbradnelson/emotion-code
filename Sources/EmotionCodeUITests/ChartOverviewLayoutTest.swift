import XCTest

// MARK: Main

final class ChartOverviewLayoutTest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
        app.buttons["Chart"].tap()
    }

}

// MARK: Tests

extension ChartOverviewLayoutTest {

    func testAllCoumnsHaveHeaders() {
        let columnHeaders = getColumnHeaders()
        XCTAssertEqual(columnHeaders.count, 2)
    }

    func testAllCoumnHeadersAreAtTheTop() {
        for index in 0 ..< 2 {
            let columnHeader = app.collectionViews.first.childrenMatchingType(.Other).matchingIdentifier("ColumnHeader_\(index)")
            let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_\(index)_0")

            let result = columnHeader.element.frame.maxY >= rowCellElement.element.frame.minY
            XCTAssert(result)
        }
    }

    func testAllCoumnHeadersAreHorizontallyAligned() {
        for index in 0 ..< 2 {
            let columnHeader = app.collectionViews.first.childrenMatchingType(.Other).matchingIdentifier("ColumnHeader_\(index)")
            let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_\(index)_0")

            let leftAligned = columnHeader.element.frame.minX == rowCellElement.element.frame.minX
            let rightAligned = columnHeader.element.frame.maxX == rowCellElement.element.frame.maxX
            let result = leftAligned && rightAligned
            XCTAssert(result)
        }
    }

    func testRowHasCounterElement() {
        let rowCounterElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCounter_0")
        XCTAssertEqual(rowCounterElement.count, 1)
    }

    func testRowCounterIsOnTheLeftOfRowCell() {
        let rowCounterElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCounter_0")
        let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")

        let result = rowCounterElement.element.frame.maxX <= rowCellElement.element.frame.minX

        XCTAssert(result)
    }

    func testRowCounterIsAlignedHorizontally() {
        let rowCounterElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCounter_0")
        let rowCellElement = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")

        let topAligned = rowCounterElement.element.frame.minY == rowCellElement.element.frame.minY
        let botAligned = rowCounterElement.element.frame.maxY == rowCellElement.element.frame.maxY

        XCTAssert(topAligned && botAligned)
    }

    func testRowCounterIsAlignedVertically() {
        let rowCounterElementTop = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCounter_0")
        let rowCounterElementBottom = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCounter_1")

        let leftAligned = rowCounterElementTop.element.frame.minX == rowCounterElementBottom.element.frame.minX
        let rightAligned = rowCounterElementTop.element.frame.maxX == rowCounterElementBottom.element.frame.maxX

        XCTAssert(leftAligned && rightAligned)
    }

    func testRowCellElementsHaveHorizontalSpacing() {
        let rowCellElementLeft = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        let rowCellElementRight = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_1_0")

        let result = rowCellElementLeft.element.frame.maxX < rowCellElementRight.element.frame.minX

        XCTAssert(result)
    }

    func testRowCellElementsHaveVerticalSpacing() {
        let rowCellElementTop = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        let rowCellElementBottom = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_1")

        let result = rowCellElementTop.element.frame.maxY <= rowCellElementBottom.element.frame.minY

        XCTAssert(result)
    }

    func testRowCellElementsAreAllignedHorizontally() {
        let rowCellElementLeft = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        let rowCellElementRight = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_1_0")

        let topAligned = rowCellElementLeft.element.frame.minY == rowCellElementRight.element.frame.minY
        let bottomAligned = rowCellElementLeft.element.frame.maxY == rowCellElementRight.element.frame.maxY

        XCTAssert(topAligned && bottomAligned)
    }

    func testRowCellElementsAreAllignedVertically() {
        let rowCellElementTop = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_0")
        let rowCellElementBottom = app.collectionViews.first.childrenMatchingType(.Any).matchingIdentifier("RowCell_0_1")

        let leftAligned = rowCellElementTop.element.frame.minX == rowCellElementBottom.element.frame.minX
        let rightAligned = rowCellElementTop.element.frame.maxX == rowCellElementBottom.element.frame.maxX

        XCTAssert(leftAligned && rightAligned)
    }

}

// MARK: Helpers

extension ChartOverviewLayoutTest {

    func getColumnHeaders() -> XCUIElementQuery {
        let childerent = app.collectionViews.first.childrenMatchingType(.Other)
        let columnHeadersPreddicate = NSPredicate { columnHeader, _ -> Bool in
            guard let columnHeader = columnHeader as? XCUIElementAttributes else { return false }
            return columnHeader.identifier.hasPrefix("ColumnHeader")
        }

        let columnHeaders = childerent.matchingPredicate(columnHeadersPreddicate)
        return columnHeaders
    }

}
