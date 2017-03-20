import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable type_body_length

struct ChartLayoutProgram: Program {

    struct Seed {
        let mode: Mode
        let itemsPerSection: [Int]
        let numberOfColumns: Int
        let topContentInset: Int
        let bottomContentInset: Int
        let viewSize: Size
    }

    enum Mode {
        case all
        case section(Int, isFocused: Bool)
        case emotion(IndexPath, isFocused: Bool)
    }

    enum Event {
        case viewWillTransition
        case viewDidTransition
        case systemDidSetViewSize(Size)
    }

    struct State {
        var mode: Mode
        let itemsPerSection: [Int]
        let numberOfColumns: Int
        let topContentInset: Int
        let bottomContentInset: Int
        var viewSize: Size

        let minViewHeightForCompactLayout = 554
        let headerSize = Size(width: 30, height: 30)
        let itemHeight = 18
        let itemPadding = 8
        let contentPadding = 10
        let sectionSpacing = Size(width: 5, height: 5)
        let itemSpacing = 10
    }

    enum Action {}

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

    static func start(with seed: Seed, perform: (Action) -> Void) -> Result<State, Failure> {
        guard seed.numberOfColumns > 0 else {
            return .failure(.invalidNumberOfColumns)
        }
        for items in seed.itemsPerSection {
            guard items >= 0 else {
                return .failure(.invalidAmountOfItems)
            }
        }
        guard seed.itemsPerSection.reduce(0, +) > 0 else {
            return .failure(.missingItems)
        }
        guard seed.viewSize.width > 0, seed.viewSize.height > 0 else {
            return .failure(.invalidViewSize)
        }
        let state = State(
            mode: seed.mode,
            itemsPerSection: seed.itemsPerSection,
            numberOfColumns: seed.numberOfColumns,
            topContentInset: seed.topContentInset,
            bottomContentInset: seed.bottomContentInset,
            viewSize: seed.viewSize
        )
        return .success(state)
    }

    static func update(for event: Event, state: inout State, perform: (Action) -> Void) -> Result<Success, Failure> {
        switch event {
        case .viewWillTransition:
            switch state.mode {
            case .all:
                return .failure(.invalidMode)
            case .section(let section, _):
                state.mode = .section(section, isFocused: false)
            case .emotion(let emotion, _):
                state.mode = .emotion(emotion, isFocused: false)
            }
        case .viewDidTransition:
            switch state.mode {
            case .all:
                return .failure(.invalidMode)
            case .section(let section, _):
                state.mode = .section(section, isFocused: true)
            case .emotion(let emotion, _):
                state.mode = .emotion(emotion, isFocused: true)
            }
        case .systemDidSetViewSize(let viewSize):
            guard viewSize.width > 0, viewSize.height > 0 else {
                return .failure(.invalidViewSize)
            }
            state.viewSize = viewSize
        }
        return .success()
    }

    static func view(for state: State) -> Result<View, Failure> {

        func rowIndex(forSection section: Int) -> Int {
            return section / state.numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return section % state.numberOfColumns
        }

        let sectionsCount = state.itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<state.numberOfColumns
        let rowsCount = Int(round(Double(sectionsCount) / Double(state.numberOfColumns)))
        let rowsRange = 0..<rowsCount

        let visibleViewSize = Size(
            width: state.viewSize.width,
            height: state.viewSize.height - state.topContentInset - state.bottomContentInset
        )

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch state.mode {
            case .all:
                return state.sectionSpacing
            case .section, .emotion:
                let width = state.contentPadding * 2
                let height = state.contentPadding + max(state.topContentInset, state.bottomContentInset)
                return .init(width: width, height: height)
            }
        }()

        let itemSpacing: Int = {
            switch state.mode {
            case .all: return 0
            case .section: return state.itemSpacing
            case .emotion: return sectionSpacing.height
            }
        }()

        //
        // MARK: -
        // MARK: Item heights
        //

        let itemHeights = sectionsRange.map { section -> Int in
            switch state.mode {
            case .all:
                guard
                    visibleViewSize.height >= state.minViewHeightForCompactLayout,
                    let maximumItemsCountInSection = state.itemsPerSection.max() else { return state.itemHeight }
                let totalSpacing = state.contentPadding * 2 + state.headerSize.height + sectionSpacing.height * rowsCount
                let totalAvailableSpacePerSection = (visibleViewSize.height - totalSpacing) / rowsCount
                return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
            case .section:
                let itemCount = state.itemsPerSection[section]
                let totalPaddingHeight = state.contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int(round(Double(totalAvailableContentHeight) / Double(itemCount)))
            case .emotion:
                return visibleViewSize.height - state.contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Label sizes
        //

        let labelSizes: [IndexPath: Size] = {
            switch state.mode {
            case .all, .section:
                return sectionsRange.reduce([:]) { labelSizes, section in
                    let width = visibleViewSize.width - state.contentPadding * 2 - state.itemPadding * 2
                    let itemCount = state.itemsPerSection[section]
                    let totalPaddingHeight = state.contentPadding * 2
                    let totalSpacingHeight = state.itemSpacing * (itemCount - 1)
                    let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                    let height = Int(round(Double(totalAvailableContentHeight) / Double(itemCount))) - state.itemPadding * 2
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
            let itemCount = state.itemsPerSection[section]
            let verticalItemSpacing = (itemCount - 1) * itemSpacing
            let totalItemHeights = itemCount * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max()!

        //
        // MARK: -
        // MARK: Row header size
        //

        let rowHeaderSize = Size(width: state.headerSize.width, height: maximumSectionHeight)

        //
        // MARK: -
        // MARK: Item width
        //

        let itemWidth: Int = {
            switch state.mode {
            case .all:
                let totalAvailableWidth = visibleViewSize.width - state.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * state.numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / state.numberOfColumns
            case .section, .emotion:
                return visibleViewSize.width - state.contentPadding * 2
            }
        }()

        //
        // MARK: -
        // MARK: Column header size
        //

        let columnHeaderSize = Size(width: itemWidth, height: state.headerSize.height)

        //
        // MARK: -
        // MARK: Column and row positions
        //

        let rowYPositions = rowsRange.map { row -> Int in
            let cumulativeContentHeight = maximumSectionHeight * row
            let cumulativeSpacingHeight = sectionSpacing.height * row
            let y = columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + state.contentPadding
            switch state.mode {
            case .all:
                return y
            case .section, .emotion:
                return y - sectionSpacing.height - columnHeaderSize.height
            }
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = state.contentPadding + rowHeaderSize.width + sectionSpacing.width
            let x = xPosition + column * (itemWidth + sectionSpacing.width)
            switch state.mode {
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
            let itemsRange = 0..<state.itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = item * itemSpacing
                let cumulativeContentHeight = item * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let itemsRange = 0..<state.itemsPerSection[section]
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
            switch state.mode {
            case .all:
                return nil
            case .section(let section, _):
                let column = columnIndex(forSection: section)
                let x = columnXPositions[column] - state.contentPadding
                let row = rowIndex(forSection: section)
                let y = rowYPositions[row] - state.contentPadding - state.topContentInset
                return Point(x: x, y: y + state.topContentInset)
            case .emotion(let indexPath, _):
                let column = columnIndex(forSection: indexPath.section)
                let x = columnXPositions[column] - state.contentPadding
                let y = yPositionsForItems[indexPath.section][indexPath.item] - state.contentPadding - state.topContentInset
                return Point(x: x, y: y + state.topContentInset)
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
            for item in 0..<state.itemsPerSection[section] {
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
                switch state.mode {
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
            switch state.mode {
            case .all: y = state.contentPadding
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
            switch state.mode {
            case .all: x = state.contentPadding
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
            switch state.mode {
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
            switch state.mode {
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
            switch state.mode {
            case .all:
                let isCompact = visibleViewSize.height >= state.minViewHeightForCompactLayout
                if isCompact { return visibleViewSize }
            case .section, .emotion:
                return visibleViewSize
            }

            let lastColumnIndexPath = IndexPath(section: state.numberOfColumns - 1)
            let lastRowIndexPath = IndexPath(section: rowsCount - 1)
            let lastColumnHeaderFrame = columnHeaders[lastColumnIndexPath]!.frame
            let lastRowHeaderFrame = rowHeaders[lastRowIndexPath]!.frame

            let width = lastColumnHeaderFrame.maxX + state.contentPadding
            let height = lastRowHeaderFrame.maxY + state.contentPadding
            return .init(width: width, height: height)
        }()

        let view = View(
            chartSize: chartSize,
            items: items,
            columnHeaders: columnHeaders,
            rowHeaders: rowHeaders,
            labelSizes: labelSizes
        )
        return .success(view)

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
