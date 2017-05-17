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
        let calculator = Calculator(numberOfRows: 1, rowHeaderWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
    }

    func testSizes2() {
        let calculator = Calculator(numberOfRows: 2, rowHeaderWidth: 4, rowHeight: 3)
        let expected = Size(width: 3, height: 4)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
        XCTAssertEqual(calculator.rowHeaders[1].frame.size, expected)
    }

    func testX1() {
        let calculator = Calculator(numberOfRows: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 2)
    }

    func testX2() {
        let calculator = Calculator(numberOfRows: 2, initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 3)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.x, 3)
    }

    func testY1() {
        let calculator = Calculator(numberOfRows: 1, initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 2)
    }

    func testY2() {
        let calculator = Calculator(numberOfRows: 2, rowHeight: 3, initialPosition(y: 4), verticalSectionSpacing: 5)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 4)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.y, 4 + 3 + 5)
    }

}

private typealias DataSource = Calculator.DataSource

private extension Calculator {
    convenience init(
        numberOfRows: Int = 1,
        alpha: Float = 1,
        rowHeaderWidth: Int = 2,
        rowHeight: Int = 3,
        initialPosition: Point = Point(x: 4, y: 5),
        verticalSectionSpacing: Int = 6
        ) {
        let dataSource = DataSource(
            numberOfRows: numberOfRows,
            alpha: alpha,
            rowHeaderWidth: rowHeaderWidth,
            rowHeight: rowHeight,
            initialPosition: initialPosition,
            verticalSectionSpacing: verticalSectionSpacing
        )
        self.init(dataSource: dataSource)
    }
}
