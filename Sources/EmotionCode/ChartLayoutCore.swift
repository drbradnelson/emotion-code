import Foundation

// swiftlint:disable mark cyclomatic_complexity type_body_length

protocol ChartLayoutCoreInterface: class {

    associatedtype Item
    associatedtype Header

    var chartSize: Size { get }
    var items: [IndexPath: Item] { get }
    var columnHeaders: [IndexPath: Header] { get }
    var rowHeaders: [IndexPath: Header] { get }
    var labelSizes: [IndexPath: Size] { get }

}

final class ChartLayoutCore {

    enum Mode {
        case all
        case section(Int, isFocused: Bool)
        case emotion(IndexPath, isFocused: Bool)
    }

//    private enum Failure: Error {
//        case missingItems
//        case invalidAmountOfItems
//        case invalidNumberOfColumns
//        case invalidViewSize
//        case invalidMode
//    }

    private struct Parameters {
        static let minViewHeightForCompactLayout = 554
        static let headerSize = Size(width: 30, height: 30)
        static let itemHeight = 18
        static let itemPadding = 8
        static let contentPadding = 10
        static let sectionSpacing = Size(width: 5, height: 5)
        static let itemSpacing = 10
    }

    struct Item {
        let frame: Rect
        let alpha: Float
    }
    typealias Header = Item

    struct View {
        let chartSize: Size
        let items: [IndexPath: Item]
        let columnHeaders: [IndexPath: Header]
        let rowHeaders: [IndexPath: Header]
        let labelSizes: [IndexPath: Size]
    }

    private var mode: Mode {
        didSet {
            view = chartView()
        }
    }
    private let itemsPerSection: [Int]
    private let numberOfColumns: Int
    private let topContentInset: Int
    private let bottomContentInset: Int
    private var viewSize: Size {
        didSet {
            view = chartView()
        }
    }

    init(mode: Mode, itemsPerSection: [Int], numberOfColumns: Int, topContentInset: Int, bottomContentInset: Int, viewSize: Size) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
        self.viewSize = viewSize
    }

    lazy var view: View = self.chartView()

    // MARK: - Actions

    func viewWillTransition() {
        switch mode {
        case .all:
            return
        case .section(let section, _):
            mode = .section(section, isFocused: false)
        case .emotion(let indexPath, _):
            mode = .emotion(indexPath, isFocused: false)
        }
    }

    func viewDidTransition() {
        switch mode {
        case .all:
            return
        case .section(let section, _):
            mode = .section(section, isFocused: true)
        case .emotion(let indexPath, _):
            mode = .emotion(indexPath, isFocused: true)
        }
    }

    func systemDidSet(viewSize: Size) {
        guard viewSize.width > 0, viewSize.height > 0 else {
            return
        }
        self.viewSize = viewSize
    }

    private var visibleViewSize: Size {
        return .init(
            width: viewSize.width,
            height: viewSize.height - topContentInset - bottomContentInset
        )
    }

    private var headerAlpha: Float {
        switch mode {
        case .all: return 1
        case .section, .emotion: return 0
        }
    }

    private var columnWidth: Int {
        switch mode {
        case .all:
            let totalHorizontalSectionSpacing = Parameters.sectionSpacing.width * numberOfColumns
            let totalHorizontalContentPadding = Parameters.contentPadding * 2
            let availableWidth = visibleViewSize.width - totalHorizontalSectionSpacing - totalHorizontalContentPadding - Parameters.headerSize.width
            return availableWidth / numberOfColumns
        case .section, .emotion:
            return visibleViewSize.width - Parameters.contentPadding * 2
        }
    }

    private var rowHeight: Int {
        switch mode {
        case .all:
            if isCompact {
                let rowsCount = Int(round(Double(itemsPerSection.count) / Double(numberOfColumns)))
                let totalSpacing = Parameters.contentPadding * 2 + Parameters.headerSize.height + sectionSpacing.height * rowsCount
                return (visibleViewSize.height - totalSpacing) / rowsCount
            } else {
                let maxItemsCountInSection = itemsPerSection.max()!
                let maxItemSpacingInSection = maxItemsCountInSection * (itemSpacing - 1)
                let maxItemHeightInSection = maxItemsCountInSection * Parameters.itemHeight
                return maxItemSpacingInSection + maxItemHeightInSection
            }
        case .section:
            return visibleViewSize.height - Parameters.contentPadding * 2
        case .emotion:
            let itemHeight = visibleViewSize.height - Parameters.contentPadding * 2
            let maxItemsCountInSection = itemsPerSection.max()!
            let maxItemSpacingInSection = (maxItemsCountInSection - 1) * itemSpacing
            return maxItemSpacingInSection + itemHeight * maxItemsCountInSection
        }
    }

    private var sectionSpacing: Size {
        switch mode {
        case .all:
            return Parameters.sectionSpacing
        case .section, .emotion:
            let width = Parameters.contentPadding * 2
            let height = Parameters.contentPadding + max(topContentInset, bottomContentInset)
            return .init(width: width, height: height)
        }
    }

    private var itemSpacing: Int {
        switch mode {
        case .all: return 0
        case .section: return Parameters.itemSpacing
        case .emotion: return sectionSpacing.height
        }
    }

    private var isCompact: Bool {
        return visibleViewSize.height >= Parameters.minViewHeightForCompactLayout
    }

    private func chartView() -> View {

        func rowIndex(forSection section: Int) -> Int {
            return section / numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return section % numberOfColumns
        }

        let sectionsCount = itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let rowsCount = Int(round(Double(itemsPerSection.count) / Double(numberOfColumns)))

        //
        // MARK: -
        // MARK: Label sizes
        //

        let labelSizes: [IndexPath: Size] = {
            switch mode {
            case .all, .section:
                return sectionsRange.reduce([:]) { labelSizes, section in
                    let width = visibleViewSize.width - Parameters.contentPadding * 2 - Parameters.itemPadding * 2
                    let itemCount = itemsPerSection[section]
                    let totalPaddingHeight = Parameters.contentPadding * 2
                    let totalSpacingHeight = itemSpacing * (itemCount - 1)
                    let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                    let height = Int(round(Double(totalAvailableContentHeight) / Double(itemCount))) - Parameters.itemPadding * 2
                    let size = Size(width: width, height: height)
                    var labelSizes = labelSizes
                    for item in 0..<itemCount {
                        let indexPath = IndexPath(item: item, section: section)
                        labelSizes[indexPath] = size
                    }
                    return labelSizes
                }
            case .emotion:
                return [:]
            }
        }()

        let itemsPosition = Point(
            x: Parameters.contentPadding + Parameters.headerSize.width + sectionSpacing.width,
            y: Parameters.contentPadding + Parameters.headerSize.height + sectionSpacing.height
        )
        let itemsCalculator = ChartLayoutItemsCalculator(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: numberOfColumns,
            columnWidth: columnWidth,
            rowHeight: rowHeight,
            initialPosition: itemsPosition,
            itemSpacing: itemSpacing,
            sectionSpacing: sectionSpacing
        )

        let columnHeadersPosition = Point(
            x: Parameters.contentPadding + Parameters.headerSize.width + sectionSpacing.width,
            y: Parameters.contentPadding
        )
        let columnHeadersCalculator = ChartLayoutColumnHeadersCalculator(
            numberOfColumns: numberOfColumns,
            alpha: headerAlpha,
            columnWidth: columnWidth,
            columnHeaderHeight: Parameters.headerSize.height,
            initialPosition: columnHeadersPosition,
            horizontalSectionSpacing: sectionSpacing.width
        )

        let rowHeadersPosition = Point(
            x: Parameters.contentPadding,
            y: Parameters.contentPadding + Parameters.headerSize.height + sectionSpacing.height
        )
        let rowHeadersCalculator = ChartLayoutRowHeadersCalculator(
            numberOfRows: rowsCount,
            alpha: headerAlpha,
            rowHeaderWidth: Parameters.headerSize.width,
            rowHeight: rowHeight,
            initialPosition: rowHeadersPosition,
            verticalSectionSpacing: sectionSpacing.height
        )

        //
        // MARK: -
        // MARK: Chart size
        //

        let contentOffset: Point? = {
            switch mode {
            case .all:
                return nil
            case .section(let section, _):
                let indexPath = IndexPath(section: section)
                let itemOffset = itemsCalculator.items[indexPath]!.frame.origin
                return Point(
                    x: itemOffset.x - Parameters.contentPadding,
                    y: itemOffset.y - Parameters.contentPadding
                )
            case .emotion(let indexPath, _):
                let itemOffset = itemsCalculator.items[indexPath]!.frame.origin
                return Point(
                    x: itemOffset.x - Parameters.contentPadding,
                    y: itemOffset.y - Parameters.contentPadding
                )
            }
        }()

        let items = itemsCalculator.items.map { indexPath, item -> (IndexPath, Item) in
            let point: Point
            switch contentOffset {
            case .some(let wrapped):
                point = item.frame.origin - wrapped
            case .none:
                point = item.frame.origin
            }
            let frame = Rect(origin: point, size: item.frame.size)
            return (indexPath, Item(frame: frame, alpha: item.alpha))
        }

        let columnHeaders: [IndexPath: Header] = {
            var headers: [IndexPath: Header] = [:]
            for (headerIndex, header) in columnHeadersCalculator.columnHeaders.enumerated() {
                let indexPath = IndexPath(section: headerIndex)
                let point: Point
                switch contentOffset {
                case .some(let wrapped):
                    point = header.frame.origin - wrapped
                case .none:
                    point = header.frame.origin
                }
                let frame = Rect(origin: point, size: header.frame.size)
                headers[indexPath] = Header(frame: frame, alpha: header.alpha)
            }
            return headers
        }()

        let rowHeaders: [IndexPath: Header] = {
            var headers: [IndexPath: Header] = [:]
            for (headerIndex, header) in rowHeadersCalculator.rowHeaders.enumerated() {
                let indexPath = IndexPath(section: headerIndex)
                let point: Point
                switch contentOffset {
                case .some(let wrapped):
                    point = header.frame.origin - wrapped
                case .none:
                    point = header.frame.origin
                }
                let frame = Rect(origin: point, size: header.frame.size)
                headers[indexPath] = Header(frame: frame, alpha: header.alpha)
            }
            return headers
        }()

        let chartSize: Size = {
            switch mode {
            case .all:
                if isCompact { return visibleViewSize }
            case .section, .emotion:
                return visibleViewSize
            }

            let lastColumnIndexPath = IndexPath(section: numberOfColumns - 1)
            let lastRowIndexPath = IndexPath(section: rowsCount - 1)
            let lastColumnHeaderFrame = columnHeaders[lastColumnIndexPath]!.frame
            let lastRowHeaderFrame = rowHeaders[lastRowIndexPath]!.frame

            let width = lastColumnHeaderFrame.maxX + Parameters.contentPadding
            let height = lastRowHeaderFrame.maxY + Parameters.contentPadding
            return .init(width: width, height: height)
        }()

        return View(
            chartSize: chartSize,
            items: items,
            columnHeaders: columnHeaders,
            rowHeaders: rowHeaders,
            labelSizes: labelSizes
        )

    }

}

private extension IndexPath {
    init(section: Int) {
        self.init(item: 0, section: section)
    }
}

private extension Dictionary {

    func map<T: Hashable, U>(transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }

}

//
// MARK: -
// MARK: Geometry
//

struct Point {

    // swiftlint:disable:next identifier_name
    var x: Int

    // swiftlint:disable:next identifier_name
    var y: Int

    static let zero = Point(x: 0, y: 0)

    public static func - (lhs: Point, rhs: Point) -> Point {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return Point(x: x, y: y)
    }

}

struct Size {

    var width: Int
    var height: Int

    static let zero = Size(width: 0, height: 0)

}

struct Rect {

    var origin: Point
    var size: Size

    var maxX: Int {
        return origin.x + size.width
    }

    var maxY: Int {
        return origin.y + size.height
    }

}
