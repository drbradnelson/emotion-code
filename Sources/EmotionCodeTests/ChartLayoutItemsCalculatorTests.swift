import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutItemsCalculator

final class ChartLayoutItemsCalculatorTests: XCTestCase {

    // MARK: - Alpha

    func testAlphaWithModeAll1() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
    }

    func testAlphaWithModeAll2() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSectionFocused1() {
        let calculator = Calculator(mode: .section(0, isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 0)
    }

    func testAlphaWithModeSectionFocused2() {
        let calculator = Calculator(mode: .section(1, isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSectionNotFocused1() {
        let calculator = Calculator(mode: .section(0, isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSectionNotFocused2() {
        let calculator = Calculator(mode: .section(1, isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionFocused1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0), isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 0)
    }

    func testAlphaWithModeEmotionFocused2() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1), isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionNotFocused1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0), isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionNotFocused2() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1), isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    // MARK: - Size

    func testSizeWithModeAll1() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1], columnWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeAll2() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

    func testSizeWithModeSection1() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1], columnWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeSection2() {
        let calculator = Calculator(mode: .section(1), itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, Size(width: 3, height: 10))
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

    func testSizeWithModeEmotion1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1], columnWidth: 2, rowHeight: 10)
        let expected = Size(width: 2, height: 10)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeEmotion2() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1)), itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, Size(width: 3, height: 10))
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

}

private typealias Mode = Calculator.Mode

private extension Mode {

    static func section(_ section: Int) -> Mode {
        return .section(section, isFocused: false)
    }

    static func emotion(_ indexPath: IndexPath) -> Mode {
        return .emotion(indexPath, isFocused: false)
    }

}

private extension Calculator {
    convenience init(
        mode: Mode = .all,
        itemsPerSection: [Int] = [1],
        numberOfColumns: Int = 1,
        visibleViewSize: Int = 2,
        initialPosition: Point = Point(x: 3, y: 4),
        columnWidth: Int = 5,
        rowHeight: Int = 6,
        itemSpacing: Int = 7,
        sectionSpacing: Size = Size(width: 8, height: 9)
        ) {
        let dataSource = DataSource(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: numberOfColumns,
            visibleViewSize: visibleViewSize,
            initialPosition: initialPosition,
            columnWidth: columnWidth,
            rowHeight: rowHeight,
            itemSpacing: itemSpacing,
            sectionSpacing: sectionSpacing
        )
        self.init(dataSource: dataSource)
    }
}
