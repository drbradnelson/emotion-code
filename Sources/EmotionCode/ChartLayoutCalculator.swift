protocol ChartLayoutCalculatorInterface: class {

    associatedtype Mode
    associatedtype Item
    associatedtype Header

    var chartSize: Size { get }
    var items: [IndexPath: Item] { get }
    var columnHeaders: [IndexPath: Header] { get }
    var rowHeaders: [IndexPath: Header] { get }
    var labelSizes: [IndexPath: Size] { get }

    init(mode: Mode, numberOfColumns: Int, itemsPerSection: [Int], viewSize: Size, topContentInset: Int, bottomContentInset: Int)

}

final class ChartLayoutCalculator: ChartLayoutCalculatorInterface {

    enum Mode {
        case all
        case section(Int, isFocused: Bool)
        case emotion(IndexPath, isFocused: Bool)
    }

    struct Item {
        let frame: Rect
        let alpha: Float
    }
    typealias Header = Item

    private struct Parameters {
        static let minViewHeightForCompactLayout = 554
        static let columnHeaderHeight = 30
        static let rowHeaderWidth = 30
        static let itemHeight = 18
        static let itemPadding = 8
        static let contentPadding = 10
        static let sectionSpacingForModeAll = Size(width: 5, height: 5)
        static let itemSpacingForModeSection = 10
    }

    private var mode: Mode
    private let numberOfColumns: Int
    private let itemsPerSection: [Int]

    private var viewSize: Size
    private let topContentInset: Int
    private let bottomContentInset: Int

    private var itemsCalculator: ChartLayoutItemsCalculatorInterface!
    private var columnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface!
    private var rowHeadersCalculator: ChartLayoutRowHeadersCalculatorInterface!

    init(mode: Mode, numberOfColumns: Int, itemsPerSection: [Int], viewSize: Size, topContentInset: Int, bottomContentInset: Int) {
        self.mode = mode
        self.numberOfColumns = numberOfColumns
        self.itemsPerSection = itemsPerSection
        self.viewSize = viewSize
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
    }

    private func updateCalculators() {
        itemsCalculator = ChartLayoutItemsCalculator(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: numberOfColumns,
            columnWidth: columnWidth,
            rowHeight: rowHeight,
            initialPosition: itemsPosition,
            itemSpacing: itemSpacing,
            sectionSpacing: sectionSpacing
        )
        columnHeadersCalculator = ChartLayoutColumnHeadersCalculator(
            mode: mode,
            numberOfColumns: numberOfColumns,
            columnWidth: columnWidth,
            columnHeaderHeight: Parameters.columnHeaderHeight,
            initialPosition: columnHeadersPosition,
            horizontalSectionSpacing: sectionSpacing.width
        )
        rowHeadersCalculator = ChartLayoutRowHeadersCalculator(
            mode: mode,
            numberOfRows: numberOfRows,
            rowHeaderWidth: Parameters.rowHeaderWidth,
            rowHeight: rowHeight,
            initialPosition: rowHeadersPosition,
            verticalSectionSpacing: sectionSpacing.height
        )
    }

    private var contentOffset: Point? {
        switch mode {
        case .all:
            return nil
        case .section(let section, _):
            let indexPath = IndexPath(item: 0, section: section)
            let itemPosition = itemsCalculator.items[indexPath]!.frame.origin
            let x = itemPosition.x - Parameters.contentPadding
            let y = itemPosition.y - Parameters.contentPadding
            return Point(x: x, y: y)
        case .emotion(let indexPath, _):
            let itemPosition = itemsCalculator.items[indexPath]!.frame.origin
            let x = itemPosition.x - Parameters.contentPadding
            let y = itemPosition.y - Parameters.contentPadding
            return Point(x: x, y: y)
        }
    }

    var chartSize: Size {
        switch mode {
        case .all:
            if isCompact { return visibleViewSize }
        case .section, .emotion:
            return visibleViewSize
        }

        let lastColumnHeaderIndexPath = IndexPath(item: 0, section: numberOfColumns - 1)
        let maxX = columnHeaders[lastColumnHeaderIndexPath]!.frame.maxX
        let lastRowHeaderIndexPath = IndexPath(item: 0, section: numberOfRows - 1)
        let maxY = rowHeaders[lastRowHeaderIndexPath]!.frame.maxY

        let width = maxX + Parameters.contentPadding
        let height = maxY + Parameters.contentPadding
        return Size(width: width, height: height)
    }

    private(set) var items: [IndexPath: Item] = [:]
    private(set) var columnHeaders: [IndexPath: Header] = [:]
    private(set) var rowHeaders: [IndexPath: Header] = [:]
    private(set) var labelSizes: [IndexPath: Size] = [:]

    private var itemsPosition: Point {
        let x = Parameters.contentPadding + Parameters.rowHeaderWidth + sectionSpacing.width
        let y = Parameters.contentPadding + Parameters.columnHeaderHeight + sectionSpacing.height
        return Point(x: x, y: y)
    }

    private var columnHeadersPosition: Point {
        let x = Parameters.contentPadding + Parameters.rowHeaderWidth + sectionSpacing.width
        let y = Parameters.contentPadding
        return Point(x: x, y: y)
    }

    private var rowHeadersPosition: Point {
        let x = Parameters.contentPadding
        let y = Parameters.contentPadding + Parameters.columnHeaderHeight + sectionSpacing.height
        return Point(x: x, y: y)
    }

    private var numberOfRows: Int {
        return Int(round(Double(itemsPerSection.count) / Double(numberOfColumns)))
    }

    private var visibleViewSize: Size {
        let height = viewSize.height - topContentInset - bottomContentInset
        return Size(width: viewSize.width, height: height)
    }

    private var isCompact: Bool {
        return visibleViewSize.height >= Parameters.minViewHeightForCompactLayout
    }

    private var sectionSpacing: Size {
        switch mode {
        case .all:
            return Parameters.sectionSpacingForModeAll
        case .section, .emotion:
            let width = Parameters.contentPadding * 2
            let height = Parameters.contentPadding + max(topContentInset, bottomContentInset)
            return .init(width: width, height: height)
        }
    }

    private var itemSpacing: Int {
        switch mode {
        case .all: return 0
        case .section: return Parameters.itemSpacingForModeSection
        case .emotion: return sectionSpacing.height
        }
    }

    private var columnWidth: Int {
        switch mode {
        case .all:
            let totalHorizontalSectionSpacing = sectionSpacing.width * numberOfColumns
            let totalHorizontalContentPadding = Parameters.contentPadding * 2
            let availableWidth = visibleViewSize.width - totalHorizontalSectionSpacing - totalHorizontalContentPadding - Parameters.rowHeaderWidth
            return availableWidth / numberOfColumns
        case .section, .emotion:
            return visibleViewSize.width - Parameters.contentPadding * 2
        }
    }

    private var rowHeightForModeAll: Int {
        if isCompact {
            let totalSpacing = Parameters.contentPadding * 2 + Parameters.columnHeaderHeight + sectionSpacing.height * numberOfRows
            return (visibleViewSize.height - totalSpacing) / numberOfRows
        }
        let maxItemsCountInSection = itemsPerSection.max()!
        let maxItemSpacingInSection = maxItemsCountInSection * (itemSpacing - 1)
        let maxItemHeightInSection = maxItemsCountInSection * Parameters.itemHeight
        return maxItemSpacingInSection + maxItemHeightInSection
    }

    private var rowHeight: Int {
        switch mode {
        case .all:
            return rowHeightForModeAll
        case .section:
            return visibleViewSize.height - Parameters.contentPadding * 2
        case .emotion:
            let itemHeight = visibleViewSize.height - Parameters.contentPadding * 2
            let maxItemsCountInSection = itemsPerSection.max()!
            let maxItemSpacingInSection = (maxItemsCountInSection - 1) * itemSpacing
            return maxItemSpacingInSection + itemHeight * maxItemsCountInSection
        }
    }

}
