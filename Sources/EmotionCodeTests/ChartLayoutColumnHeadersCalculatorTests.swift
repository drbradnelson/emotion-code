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
        numberOfColumns: Int = 1,
        alpha: Float = 1,
        initialPosition: Point = Point(x: 2, y: 3),
        columnWidth: Int = 4,
        columnHeaderHeight: Int = 5,
        horizontalSectionSpacing: Int = 6
    ) {
        self.init(
            numberOfColumns: numberOfColumns,
            alpha: alpha,
            columnWidth: columnWidth,
            columnHeaderHeight: columnHeaderHeight,
            initialPosition: initialPosition,
            horizontalSectionSpacing: horizontalSectionSpacing
        )
    }
}

extension Size: Equatable {
    public static func == (lhs: Size, rhs: Size) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Point {
    // swiftlint:disable:next identifier_name
    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }
}
