import XCTest

@testable import EmotionCode

private typealias Calculator = ChartLayoutItemsCalculator

final class ChartLayoutItemsCalculatorTests: XCTestCase {

    // MARK: - Count

    func testCountWith1SectionAnd1Item() {
        let calculator = Calculator(itemsPerSection: [1])
        XCTAssertEqual(calculator.items.count, 1)
    }

    func testCountWith2SectionsAnd3Items() {
        let calculator = Calculator(itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items.count, 1 + 2)
    }

    // MARK: - Alpha

    func testAlphaWithModeAll() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
    }

    func testAlphaWithModeAllAndMoreItems() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSection0Focused() {
        let calculator = Calculator(mode: .section(0, isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 0)
    }

    func testAlphaWithModeSection1Focused() {
        let calculator = Calculator(mode: .section(1, isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSection0NotFocused() {
        let calculator = Calculator(mode: .section(0, isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeSection1NotFocused() {
        let calculator = Calculator(mode: .section(1, isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionItem0Section0Focused() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0), isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 0)
    }

    func testAlphaWithModeEmotionItem1Section1Focused() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1), isFocused: true), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 0)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionItem0Section0NotFocused() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0), isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    func testAlphaWithModeEmotionItem1Section1NotFocused() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1), isFocused: false), itemsPerSection: [1, 2])
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.alpha, 1)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.alpha, 1)
    }

    // MARK: - Size

    func testSizeWithModeAll() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1], columnWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeAllAndMoreItems() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

    func testSizeWithModeSection0() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1], columnWidth: 2, rowHeight: 3)
        let expected = Size(width: 2, height: 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeSection1() {
        let calculator = Calculator(mode: .section(1), itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, Size(width: 3, height: 10))
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

    func testSizeWithModeEmotionItem0Section0() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1], columnWidth: 2, rowHeight: 10)
        let expected = Size(width: 2, height: 10)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, expected)
    }

    func testSizeWithModeEmotionItem1Section1() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1)), itemsPerSection: [1, 2], columnWidth: 3, rowHeight: 10, itemSpacing: 4)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.size, Size(width: 3, height: 10))
        let expected = Size(width: 3, height: (10 - 4) / 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.size, expected)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.size, expected)
    }

    // MARK: - X offset

    func testXWithModeAll() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXWithModeAllAndMoreItemsAnd1Column() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXWithModeAllAndMoreItemsAnd2Columns() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
    }

    func testXWithModeSection0() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXWithModeSection0AndMoreItems() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXWithModeSection1AndMoreItems() {
        let calculator = Calculator(mode: .section(1), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
    }

    func testXWithModeEmotionItem0Section0() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
    }

    func testXWithModeEmotionItem0Section1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 1)), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(x: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 2)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 2)
    }

    func testXWithModeEmotionItem1Section1() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1)), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(x: 3), columnWidth: 4, sectionSpacing: Size(width: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.x, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.x, 3 + 4 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.x, 3 + 4 + 5)
    }

    // MARK: - Y offset

    func testYWithModeAll() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1], initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 2)
    }

    func testYWithModeAllAndMoreItemsAnd1Column() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3 + 10 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + 10 + 5 + itemHeight + 4)
    }

    func testYWithModeAllAndMoreItemsAnd2Columns() {
        let calculator = Calculator(mode: .all, itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + itemHeight + 4)
    }

    func testYWithModeSection0() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1], initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 2)
    }

    func testYWithModeSection0AndMoreItemsAnd1Column() {
        let calculator = Calculator(mode: .section(0), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3 + 10 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + 10 + 5 + itemHeight + 4)
    }

    func testYWithModeSection1AndMoreItemsAnd2Columns() {
        let calculator = Calculator(mode: .section(1), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + itemHeight + 4)
    }

    func testYWithModeEmotionItem0Section0() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 0)), itemsPerSection: [1], initialPosition: Point(y: 2))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 2)
    }

    func testYWithModeEmotionItem0Section1() {
        let calculator = Calculator(mode: .emotion(.init(item: 0, section: 1)), itemsPerSection: [1, 2], numberOfColumns: 1, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3 + 10 + 5)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + 10 + 5 + itemHeight + 4)
    }

    func testYWithModeEmotionItem1Section1() {
        let calculator = Calculator(mode: .emotion(.init(item: 1, section: 1)), itemsPerSection: [1, 2], numberOfColumns: 2, initialPosition: Point(y: 3), rowHeight: 10, itemSpacing: 4, sectionSpacing: Size(height: 5))
        XCTAssertEqual(calculator.items[.init(item: 0, section: 0)]!.frame.origin.y, 3)
        let itemHeight = (10 - 4) / 2
        XCTAssertEqual(calculator.items[.init(item: 0, section: 1)]!.frame.origin.y, 3)
        XCTAssertEqual(calculator.items[.init(item: 1, section: 1)]!.frame.origin.y, 3 + itemHeight + 4)
    }

}

private extension Mode {

    static func section(_ section: Int) -> Mode {
        return .section(section, isFocused: false)
    }

    static func emotion(_ indexPath: IndexPath) -> Mode {
        return .emotion(indexPath, isFocused: false)
    }

}

private extension Size {
    init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
}

private extension Calculator {
    convenience init(
        mode: Mode = .all,
        itemsPerSection: [Int] = [1],
        numberOfColumns: Int = 1,
        initialPosition: Point = Point(x: 4, y: 5),
        columnWidth: Int = 6,
        rowHeight: Int = 7,
        itemSpacing: Int = 8,
        sectionSpacing: Size = Size(width: 9, height: 10)
    ) {
        self.init(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: numberOfColumns,
            columnWidth: columnWidth,
            rowHeight: rowHeight,
            initialPosition: initialPosition,
            itemSpacing: itemSpacing,
            sectionSpacing: sectionSpacing
        )
    }
}
