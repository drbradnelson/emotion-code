import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutRowHeadersCalculator

final class ChartLayoutRowHeadersCalculatorTests: XCTestCase {

    func testCount1() {
        let calculator = Calculator(numberOfRows: 1)
        XCTAssertEqual(calculator.rowHeaders.count, 1)
    }

    func testCount2() {
        let calculator = Calculator(numberOfRows: 2)
        XCTAssertEqual(calculator.rowHeaders.count, 2)
    }

    func testAlpha1() {
        let calculator = Calculator(numberOfRows: 1, alpha: 0)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 0)
    }

    func testAlpha2() {
        let calculator = Calculator(numberOfRows: 2, alpha: 1)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 1)
        XCTAssertEqual(calculator.rowHeaders[1].alpha, 1)
    }

    func testSizes1() {
        let calculator = Calculator(numberOfRows: 1, sectionHeight: 2, rowHeaderWidth: 3)
        let expected = Size(width: 3, height: 2)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
    }

    func testSizes2() {
        let calculator = Calculator(numberOfRows: 2, sectionHeight: 3, rowHeaderWidth: 4)
        let expected = Size(width: 4, height: 3)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
        XCTAssertEqual(calculator.rowHeaders[1].frame.size, expected)
    }

    func testX1() {
        let calculator = Calculator(numberOfRows: 1, contentPadding: 2)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 2)
    }

    func testX2() {
        let calculator = Calculator(numberOfRows: 2, contentPadding: 3)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 3)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.x, 3)
    }

    func testY1() {
        let calculator = Calculator(numberOfRows: 1, contentPadding: 2, columnHeaderHeight: 3, verticalSectionSpacing: 4)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 2 + 3 + 4)
    }

    func testY2() {
        let calculator = Calculator(numberOfRows: 2, sectionHeight: 3, contentPadding: 4, columnHeaderHeight: 5, verticalSectionSpacing: 6)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 4 + 5 + 6)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.y, 4 + 5 + 6 + 3 + 6)
    }

}

private typealias DataSource = Calculator.DataSource

private extension Calculator {
    convenience init(
        numberOfRows: Int = 1,
        alpha: Float = 1,
        sectionHeight: Int = 2,
        contentPadding: Int = 3,
        rowHeaderWidth: Int = 4,
        columnHeaderHeight: Int = 5,
        verticalSectionSpacing: Int = 6
        ) {
        let dataSource = DataSource(
            numberOfRows: numberOfRows,
            alpha: alpha,
            sectionHeight: sectionHeight,
            contentPadding: contentPadding,
            rowHeaderWidth: rowHeaderWidth,
            columnHeaderHeight: columnHeaderHeight,
            verticalSectionSpacing: verticalSectionSpacing
        )
        self.init(dataSource: dataSource)
    }
}
