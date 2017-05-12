import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutItemsCalculator

final class ChartLayoutItemsCalculatorTests: XCTestCase {

    func testAlphasWithModeAll1() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
    }

    func testAlphasWithModeAll2() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

}
