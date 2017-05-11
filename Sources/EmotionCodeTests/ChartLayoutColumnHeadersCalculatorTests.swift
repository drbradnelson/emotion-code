import XCTest

@testable import EmotionCode

typealias Calculator = ChartLayoutColumnHeadersCalculator

final class ChartLayoutColumnHeadersCalculatorTests: XCTestCase {

    func testCount1() {
        let calculator = Calculator(numberOfColumns: 1)
        XCTAssertEqual(calculator.columnHeaders.count, 1)
    }

    func testCount2() {
        let calculator = Calculator(numberOfColumns: 2)
        XCTAssertEqual(calculator.columnHeaders.count, 2)
    }

    func testAlpha1() {
        let calculator = Calculator(numberOfColumns: 1, alpha: 0)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 0)
    }

    func testAlpha2() {
        let calculator = Calculator(numberOfColumns: 2, alpha: 1)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 1)
        XCTAssertEqual(calculator.columnHeaders[1].alpha, 1)
    }

    func testSizes1() {
        let calculator = Calculator(numberOfColumns: 1, columnWidth: 2, columnHeaderHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.columnHeaders[0].frame.size, expected)
    }

    func testSizes2() {
        let calculator = Calculator(numberOfColumns: 2, columnWidth: 3, columnHeaderHeight: 4)
        let expected = Size(width: 3, height: 4)
        XCTAssertEqual(calculator.columnHeaders[0].frame.size, expected)
        XCTAssertEqual(calculator.columnHeaders[1].frame.size, expected)
    }

    func testX1() {
        let calculator = Calculator(numberOfColumns: 1, contentPadding: 2, rowHeaderWidth: 3, horizontalSectionSpacing: 4)
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.x, 2 + 3 + 4)
    }

    func testX2() {
        let calculator = Calculator(numberOfColumns: 2, columnWidth: 3, contentPadding: 4, rowHeaderWidth: 5, horizontalSectionSpacing: 6)
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.x, 4 + 5 + 6)
        XCTAssertEqual(calculator.columnHeaders[1].frame.origin.x, 4 + 5 + 6 + 3 + 6)
    }

    func testY1() {
        let calculator = Calculator(numberOfColumns: 1, contentPadding: 2)
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.y, 2)
    }

    func testY2() {
        let calculator = Calculator(numberOfColumns: 2, contentPadding: 3)
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.y, 3)
        XCTAssertEqual(calculator.columnHeaders[1].frame.origin.y, 3)
    }

}

typealias DataSource = Calculator.DataSource

private extension Calculator {
    convenience init(
        numberOfColumns: Int = 1,
        alpha: Float = 1,
        columnWidth: Int = 2,
        contentPadding: Int = 3,
        rowHeaderWidth: Int = 4,
        columnHeaderHeight: Int = 5,
        horizontalSectionSpacing: Int = 6
    ) {
        let dataSource = DataSource(
            numberOfColumns: numberOfColumns,
            alpha: alpha,
            columnWidth: columnWidth,
            contentPadding: contentPadding,
            rowHeaderWidth: rowHeaderWidth,
            columnHeaderHeight: columnHeaderHeight,
            horizontalSectionSpacing: horizontalSectionSpacing
        )
        self.init(dataSource: dataSource)
    }
}

extension Size: Equatable {
    public static func == (lhs: Size, rhs: Size) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
