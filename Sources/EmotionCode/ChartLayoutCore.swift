import Foundation

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable type_body_length

final class ChartLayoutCore {

    enum Mode {
        case all
        case section(Int, isFocused: Bool)
        case emotion(IndexPath, isFocused: Bool)
    }

    private var mode: Mode
    private let itemsPerSection: [Int]
    private let numberOfColumns: Int
    private let topContentInset: Int
    private let bottomContentInset: Int
    private var viewSize: Size

    init(mode: Mode, itemsPerSection: [Int], numberOfColumns: Int, topContentInset: Int, bottomContentInset: Int, viewSize: Size) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
        self.viewSize = viewSize
    }

    private let minViewHeightForCompactLayout = 554
    private let headerSize = Size(width: 30, height: 30)
    private let itemHeight = 18
    private let itemPadding = 8
    private let contentPadding = 10
    private let sectionSpacing = Size(width: 5, height: 5)
    private let itemSpacing = 10

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

    enum Failure: Error {
        case missingItems
        case invalidAmountOfItems
        case invalidNumberOfColumns
        case invalidViewSize
        case invalidMode
    }

    func viewWillTransition() {
        switch mode {
        case .all:
            //            throw Failure.invalidMode
            return
        case .section(let section, _):
            mode = .section(section, isFocused: false)
        case .emotion(let indexPath, _):
            mode = .emotion(indexPath, isFocused: false)
        }
        view = chartView()
    }

    func viewDidTransition() {
        switch mode {
        case .all:
            //            throw Failure.invalidMode
            return
        case .section(let section, _):
            mode = .section(section, isFocused: true)
        case .emotion(let indexPath, _):
            mode = .emotion(indexPath, isFocused: true)
        }
        view = chartView()
    }

    func systemDidSet(viewSize: Size) {
        guard viewSize.width > 0, viewSize.height > 0 else {
            //            throw Failure.invalidViewSize
            return
        }
        self.viewSize = viewSize
        view = chartView()
    }

    lazy var view: View = self.chartView()

    func chartView() -> View {

        func rowIndex(forSection section: Int) -> Int {
            return section / numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return section % numberOfColumns
        }

        let sectionsCount = itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<numberOfColumns
        let rowsCount = Int(round(Double(sectionsCount) / Double(numberOfColumns)))
        let rowsRange = 0..<rowsCount

        let visibleViewSize = Size(
            width: viewSize.width,
            height: viewSize.height - topContentInset - bottomContentInset
        )

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch mode {
            case .all:
                return self.sectionSpacing
            case .section, .emotion:
                let width = contentPadding * 2
                let height = contentPadding + max(topContentInset, bottomContentInset)
                return .init(width: width, height: height)
            }
        }()

        let itemSpacing: Int = {
            switch mode {
            case .all: return 0
            case .section: return self.itemSpacing
            case .emotion: return sectionSpacing.height
            }
        }()

        //
        // MARK: -
        // MARK: Item heights
        //

        let itemHeights = sectionsRange.map { section -> Int in
            switch mode {
            case .all:
                guard
                    visibleViewSize.height >= minViewHeightForCompactLayout,
                    let maximumItemsCountInSection = itemsPerSection.max() else { return itemHeight }
                let totalSpacing = contentPadding * 2 + headerSize.height + sectionSpacing.height * rowsCount
                let totalAvailableSpacePerSection = (visibleViewSize.height - totalSpacing) / rowsCount
                return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
            case .section:
                let itemCount = itemsPerSection[section]
                let totalPaddingHeight = contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int(round(Double(totalAvailableContentHeight) / Double(itemCount)))
            case .emotion:
                return visibleViewSize.height - contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Label sizes
        //

        let labelSizes: [IndexPath: Size] = {
            switch mode {
            case .all, .section:
                return sectionsRange.reduce([:]) { labelSizes, section in
                    let width = visibleViewSize.width - contentPadding * 2 - itemPadding * 2
                    let itemCount = itemsPerSection[section]
                    let totalPaddingHeight = contentPadding * 2
                    let totalSpacingHeight = itemSpacing * (itemCount - 1)
                    let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                    let height = Int(round(Double(totalAvailableContentHeight) / Double(itemCount))) - itemPadding * 2
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

        //
        // MARK: -
        // MARK: Section height
        //

        let sectionHeights = sectionsRange.map { section -> Int in
            let itemCount = itemsPerSection[section]
            let verticalItemSpacing = (itemCount - 1) * itemSpacing
            let totalItemHeights = itemCount * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max()!

        //
        // MARK: -
        // MARK: Row header size
        //

        let rowHeaderSize = Size(width: headerSize.width, height: maximumSectionHeight)

        //
        // MARK: -
        // MARK: Item width
        //

        let itemWidth: Int = {
            switch mode {
            case .all:
                let totalAvailableWidth = visibleViewSize.width - contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / numberOfColumns
            case .section, .emotion:
                return visibleViewSize.width - contentPadding * 2
            }
        }()

        //
        // MARK: -
        // MARK: Column header size
        //

        let columnHeaderSize = Size(width: itemWidth, height: headerSize.height)

        //
        // MARK: -
        // MARK: Column and row positions
        //

        let rowYPositions = rowsRange.map { row -> Int in
            let cumulativeContentHeight = maximumSectionHeight * row
            let cumulativeSpacingHeight = sectionSpacing.height * row
            let y = columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + contentPadding
            switch mode {
            case .all:
                return y
            case .section, .emotion:
                return y - sectionSpacing.height - columnHeaderSize.height
            }
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = contentPadding + rowHeaderSize.width + sectionSpacing.width
            let x = xPosition + column * (itemWidth + sectionSpacing.width)
            switch mode {
            case .all:
                return x
            case .section, .emotion:
                return x - sectionSpacing.width - rowHeaderSize.width
            }
        }

        //
        // MARK: -
        // MARK: Item position
        //

        let yPositionsForItems = sectionsRange.map { section -> [Int] in
            let itemsRange = 0..<itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = item * itemSpacing
                let cumulativeContentHeight = item * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let itemsRange = 0..<itemsPerSection[section]
            let column = columnIndex(forSection: section)

            let xPosition = columnXPositions[column]
            return itemsRange.map { item in
                let yPosition = yPositionsForItems[section][item]
                return Point(x: xPosition, y: yPosition)
            }
        }

        //
        // MARK: -
        // MARK: Content offset
        //

        let proposedContentOffset: Point? = {
            switch mode {
            case .all:
                return nil
            case .section(let section, _):
                let column = columnIndex(forSection: section)
                let x = columnXPositions[column] - contentPadding
                let row = rowIndex(forSection: section)
                let y = rowYPositions[row] - contentPadding - topContentInset
                return Point(x: x, y: y + topContentInset)
            case .emotion(let indexPath, _):
                let column = columnIndex(forSection: indexPath.section)
                let x = columnXPositions[column] - contentPadding
                let y = yPositionsForItems[indexPath.section][indexPath.item] - contentPadding - topContentInset
                return Point(x: x, y: y + topContentInset)
            }
        }()

        //
        // MARK: -
        // MARK: Items
        //

        let items: [IndexPath: Item] = sectionsRange.reduce([:]) { items, section in
            let height = itemHeights[section]
            let size = Size(width: itemWidth, height: height)
            var items = items
            for item in 0..<itemsPerSection[section] {
                let itemPosition = itemPositions[section][item]
                let position: Point
                switch proposedContentOffset {
                case .some(let proposedContentOffset):
                    position = .init(
                        x: itemPosition.x - proposedContentOffset.x,
                        y: itemPosition.y - proposedContentOffset.y
                    )
                case .none:
                    position = itemPosition
                }
                let alpha: Float
                switch mode {
                case .all:
                    alpha = 1
                case .section(let currentSection, let isFocused):
                    alpha = (!isFocused || currentSection == section) ? 1 : 0
                case .emotion(let indexPath, let isFocused):
                    alpha = (!isFocused || indexPath.item == item && indexPath.section == section) ? 1 : 0
                }
                let frame = Rect(origin: position, size: size)
                let indexPath = IndexPath(item: item, section: section)
                items[indexPath] = Header(frame: frame, alpha: alpha)
            }
            return items
        }

        //
        // MARK: -
        // MARK: Header position
        //

        let positionsForColumnHeaders = columnsRange.map { column -> Point in
            let x = columnXPositions[column]
            let y: Int
            switch mode {
            case .all: y = contentPadding
            case .section, .emotion: y = -columnHeaderSize.height
            }
            let position: Point
            switch proposedContentOffset {
            case .some(let proposedContentOffset):
                position = .init(
                    x: x - proposedContentOffset.x,
                    y: y - proposedContentOffset.y
                )
            case .none:
                position = .init(x: x, y: y)
            }
            return position
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let x: Int
            switch mode {
            case .all: x = contentPadding
            case .section, .emotion: x = -rowHeaderSize.width
            }
            let y = rowYPositions[row]
            let position: Point
            switch proposedContentOffset {
            case .some(let proposedContentOffset):
                position = .init(
                    x: x - proposedContentOffset.x,
                    y: y - proposedContentOffset.y
                )
            case .none:
                position = .init(x: x, y: y)
            }
            return position
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaders: [IndexPath: Header] = columnsRange.reduce([:]) { headers, column in
            let position = positionsForColumnHeaders[column]
            let frame = Rect(origin: position, size: columnHeaderSize)
            let alpha: Float
            switch mode {
            case .all:
                alpha = 1
            case .section, .emotion:
                alpha = 0
            }
            let indexPath = IndexPath(section: column)
            var headers = headers
            headers[indexPath] = Header(frame: frame, alpha: alpha)
            return headers
        }

        let rowHeaders: [IndexPath: Header] = rowsRange.reduce([:]) { headers, row in
            let position = positionsForRowHeaders[row]
            let frame = Rect(origin: position, size: rowHeaderSize)
            let alpha: Float
            switch mode {
            case .all:
                alpha = 1
            case .section, .emotion:
                alpha = 0
            }
            let indexPath = IndexPath(section: row)
            var headers = headers
            headers[indexPath] = Header(frame: frame, alpha: alpha)
            return headers
        }

        //
        // MARK: -
        // MARK: Chart size
        //

        let chartSize: Size = {
            switch mode {
            case .all:
                let isCompact = visibleViewSize.height >= minViewHeightForCompactLayout
                if isCompact { return visibleViewSize }
            case .section, .emotion:
                return visibleViewSize
            }

            let lastColumnIndexPath = IndexPath(section: numberOfColumns - 1)
            let lastRowIndexPath = IndexPath(section: rowsCount - 1)
            let lastColumnHeaderFrame = columnHeaders[lastColumnIndexPath]!.frame
            let lastRowHeaderFrame = rowHeaders[lastRowIndexPath]!.frame

            let width = lastColumnHeaderFrame.maxX + contentPadding
            let height = lastRowHeaderFrame.maxY + contentPadding
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

//
// MARK: -
// MARK: Geometry
//

public struct Point {

    // swiftlint:disable:next variable_name
    var x: Int

    // swiftlint:disable:next variable_name
    var y: Int

    static let zero = Point(x: 0, y: 0)

}

public struct Size {

    var width: Int
    var height: Int

    static let zero = Size(width: 0, height: 0)

}

public struct Rect {

    var origin: Point
    var size: Size

    var maxX: Int {
        return origin.x + size.width
    }

    var maxY: Int {
        return origin.y + size.height
    }

}
