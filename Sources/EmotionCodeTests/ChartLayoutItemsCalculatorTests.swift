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

    // MARK: - X offset

    func testXModeAll1() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXModeAll2() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXModeAll3() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5, height: 0))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
    }

    func testXModeSection1() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXModeSection2() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXModeSection3() {
        let calculator = Calculator(mode: .section(1), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5, height: 0))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
    }

    func testXModeEmotion1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXModeEmotion2() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXModeEmotion3() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1)), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5, height: 0))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
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
        visibleViewSize: Size = Size(width: 2, height: 3),
        initialPosition: Point = Point(x: 4, y: 5),
        columnWidth: Int = 6,
        rowHeight: Int = 7,
        itemSpacing: Int = 8,
        sectionSpacing: Size = Size(width: 9, height: 10)
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
