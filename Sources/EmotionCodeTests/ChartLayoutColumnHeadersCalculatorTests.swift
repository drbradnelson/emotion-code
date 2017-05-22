import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutColumnHeadersCalculator

final class ChartLayoutColumnHeadersCalculatorTests: XCTestCase {

    func testCount1() {
        let calculator = Calculator(numberOfColumns: 1)
        XCTAssertEqual(calculator.columnHeaders.count, 1)
    }

    func testCount2() {
        let calculator = Calculator(numberOfColumns: 2)
        XCTAssertEqual(calculator.columnHeaders.count, 2)
    }

    func testAlphaModeAll1() {
        let calculator = Calculator(mode: .all, numberOfColumns: 1)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 1)
    }

    func testAlphaModeAll2() {
        let calculator = Calculator(mode: .all, numberOfColumns: 2)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 1)
        XCTAssertEqual(calculator.columnHeaders[1].alpha, 1)
    }

    func testAlphaModeSection1() {
        let calculator = Calculator(mode: .section, numberOfColumns: 1)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 0)
    }

    func testAlphaModeSection2() {
        let calculator = Calculator(mode: .section, numberOfColumns: 2)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 0)
        XCTAssertEqual(calculator.columnHeaders[1].alpha, 0)
    }

    func testAlphaModeEmotion1() {
        let calculator = Calculator(mode: .emotion, numberOfColumns: 1)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 0)
    }

    func testAlphaModeEmotion2() {
        let calculator = Calculator(mode: .emotion, numberOfColumns: 2)
        XCTAssertEqual(calculator.columnHeaders[0].alpha, 0)
        XCTAssertEqual(calculator.columnHeaders[1].alpha, 0)
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
        let calculator = Calculator(numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.x, 2)
    }

    func testX2() {
        let calculator = Calculator(numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, horizontalSectionSpacing: 5)
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.x, 3)
        XCTAssertEqual(calculator.columnHeaders[1].frame.origin.x, 3 + 4 + 5)
    }

    func testY1() {
        let calculator = Calculator(numberOfColumns: 1, initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.y, 2)
    }

    func testY2() {
        let calculator = Calculator(numberOfColumns: 2, initialPosition: Point(y: 3))
        XCTAssertEqual(calculator.columnHeaders[0].frame.origin.y, 3)
        XCTAssertEqual(calculator.columnHeaders[1].frame.origin.y, 3)
    }

}

private extension Calculator {
    convenience init(
        mode: Mode = .all,
        numberOfColumns: Int = 1,
        initialPosition: Point = Point(x: 2, y: 3),
        columnWidth: Int = 4,
        columnHeaderHeight: Int = 5,
        horizontalSectionSpacing: Int = 6
    ) {
        self.init(
            mode: mode,
            numberOfColumns: numberOfColumns,
            columnWidth: columnWidth,
            columnHeaderHeight: columnHeaderHeight,
            initialPosition: initialPosition,
            horizontalSectionSpacing: horizontalSectionSpacing
        )
    }
}
