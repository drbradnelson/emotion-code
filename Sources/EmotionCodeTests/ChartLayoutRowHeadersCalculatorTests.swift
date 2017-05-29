import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutRowHeadersCalculator

final class ChartLayoutRowHeadersCalculatorTests: XCTestCase {

    // MARK: - Count

    func testCountWith1Row() {
        let calculator = Calculator(numberOfRows: 1)
        XCTAssertEqual(calculator.rowHeaders.count, 1)
    }

    func testCountWith2Rows() {
        let calculator = Calculator(numberOfRows: 2)
        XCTAssertEqual(calculator.rowHeaders.count, 2)
    }

    // MARK: - Alpha

    func testAlphaWithModeAllWith1Row() {
        let calculator = Calculator(mode: .all, numberOfRows: 1)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 1)
    }

    func testAlphaWithModeAllWith2Rows() {
        let calculator = Calculator(mode: .all, numberOfRows: 2)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 1)
        XCTAssertEqual(calculator.rowHeaders[1].alpha, 1)
    }

    func testAlphaWithModeSectionAnd1Row() {
        let calculator = Calculator(mode: .section, numberOfRows: 1)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 0)
    }

    func testAlphaWithModeSectionAnd2Rows() {
        let calculator = Calculator(mode: .section, numberOfRows: 2)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 0)
        XCTAssertEqual(calculator.rowHeaders[1].alpha, 0)
    }

    func testAlphaWithModeEmotionAnd1Row() {
        let calculator = Calculator(mode: .emotion, numberOfRows: 1)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 0)
    }

    func testAlphaWithModeEmotionAnd2Rows() {
        let calculator = Calculator(mode: .emotion, numberOfRows: 2)
        XCTAssertEqual(calculator.rowHeaders[0].alpha, 0)
        XCTAssertEqual(calculator.rowHeaders[1].alpha, 0)
    }

    // MARK: - Size

    func testSizesWith1Row() {
        let calculator = Calculator(numberOfRows: 1, rowHeaderWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
    }

    func testSizesWith2Rows() {
        let calculator = Calculator(numberOfRows: 2, rowHeaderWidth: 3, rowHeight: 4)
        let expected = Size(width: 3, height: 4)
        XCTAssertEqual(calculator.rowHeaders[0].frame.size, expected)
        XCTAssertEqual(calculator.rowHeaders[1].frame.size, expected)
    }

    // MARK: - X offset

    func testXWith1Row() {
        let calculator = Calculator(numberOfRows: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 2)
    }

    func testXWith2Rows() {
        let calculator = Calculator(numberOfRows: 2, initialPosition: Point(x: 3))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.x, 3)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.x, 3)
    }

    // MARK: - Y offset

    func testYWith1Row() {
        let calculator = Calculator(numberOfRows: 1, initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 2)
    }

    func testYWith2Rows() {
        let calculator = Calculator(numberOfRows: 2, initialPosition: Point(y: 3), rowHeight: 4, verticalSectionSpacing: 5)
        XCTAssertEqual(calculator.rowHeaders[0].frame.origin.y, 3)
        XCTAssertEqual(calculator.rowHeaders[1].frame.origin.y, 3 + 4 + 5)
    }

}

private extension Calculator {
    convenience init(
        mode: Mode = .all,
        numberOfRows: Int = 1,
        initialPosition: Point = Point(x: 2, y: 3),
        rowHeaderWidth: Int = 4,
        rowHeight: Int = 5,
        verticalSectionSpacing: Int = 6
    ) {
        self.init(
            mode: mode,
            numberOfRows: numberOfRows,
            rowHeaderWidth: rowHeaderWidth,
            rowHeight: rowHeight,
            initialPosition: initialPosition,
            verticalSectionSpacing: verticalSectionSpacing
        )
    }
}
