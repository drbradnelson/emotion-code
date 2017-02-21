import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable type_body_length

struct ChartLayoutModule: Elm.Module {

    struct Flags {
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

    enum Message {
        case viewWillTransition
        case viewDidTransition
        case systemDidSetViewSize(Size)
    }

    struct Model {
        let flags: Flags
        let minViewHeightForCompactLayout = 554
        let headerSize = Size(width: 30, height: 30)
        let itemHeight = 30
        let contentPadding = 10
        let sectionSpacing = Size(width: 5, height: 5)
        let itemSpacing = 10
    }

    typealias Command = Void

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
    }

    enum Failure: Error {
        case missingItems
        case invalidItems
        case invalidNumberOfColums
        case invalidViewSize
        case invalidMode
    }

    public static func start(with flags: Flags, perform: (Command) -> Void) throws -> Model {
        guard flags.numberOfColumns > 0 else {
            throw Failure.invalidNumberOfColums
        }
        for items in flags.itemsPerSection {
            guard items >= 0 else {
                throw Failure.invalidItems
            }
        }
        guard flags.itemsPerSection.reduce(0, +) > 0 else {
            throw Failure.missingItems
        }
        guard flags.viewSize.width > 0, flags.viewSize.height > 0 else {
            throw Failure.invalidViewSize
        }
        return Model(flags: flags)
    }

    static func update(for message: Message, model: inout Model, perform: (Command) -> Void) throws {
        switch message {
        case .viewWillTransition:
            switch model.flags.mode {
            case .all:
                throw Failure.invalidMode
            case .section(let section, _):
                model = Model(flags: .init(
                    mode: .section(section, isFocused: false),
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset,
                    bottomContentInset: model.flags.bottomContentInset,
                    viewSize: model.flags.viewSize
                ))
            case .emotion(let emotion, _):
                model = Model(flags: .init(
                    mode: .emotion(emotion, isFocused: false),
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset,
                    bottomContentInset: model.flags.bottomContentInset,
                    viewSize: model.flags.viewSize
                ))
            }
        case .viewDidTransition:
            switch model.flags.mode {
            case .all:
                throw Failure.invalidMode
            case .section(let section, _):
                model = Model(flags: .init(
                    mode: .section(section, isFocused: true),
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset,
                    bottomContentInset: model.flags.bottomContentInset,
                    viewSize: model.flags.viewSize
                ))
            case .emotion(let emotion, _):
                model = Model(flags: .init(
                    mode: .emotion(emotion, isFocused: true),
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset,
                    bottomContentInset: model.flags.bottomContentInset,
                    viewSize: model.flags.viewSize
                ))
            }
        case .systemDidSetViewSize(let viewSize):
            guard viewSize.width > 0, viewSize.height > 0 else {
                throw Failure.invalidViewSize
            }
            model = Model(
                flags: .init(
                    mode: model.flags.mode,
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset,
                    bottomContentInset: model.flags.bottomContentInset,
                    viewSize: viewSize
                )
            )
        }
    }

    static func view(for model: Model) throws -> View {

        func rowIndex(forSection section: Int) -> Int {
            return section / model.flags.numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return section % model.flags.numberOfColumns
        }

        let sectionsCount = model.flags.itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<model.flags.numberOfColumns
        let rowsCount = Int(round(Double(sectionsCount) / Double(model.flags.numberOfColumns)))
        let rowsRange = 0..<rowsCount

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch model.flags.mode {
            case .all:
                return model.sectionSpacing
            case .section, .emotion:
                let width = model.contentPadding * 2
                let height = model.contentPadding + max(model.flags.topContentInset, model.flags.bottomContentInset)
                return .init(width: width, height: height)
            }
        }()

        let itemSpacing: Int = {
            switch model.flags.mode {
            case .all: return 0
            case .section: return model.itemSpacing
            case .emotion: return sectionSpacing.height
            }
        }()

        //
        // MARK: -
        // MARK: Item heights
        //

        let itemHeight: Int = {
            guard
                model.flags.viewSize.height >= model.minViewHeightForCompactLayout,
                let maximumItemsCountInSection = model.flags.itemsPerSection.max() else { return model.itemHeight }
            let totalSpacing = model.contentPadding * 2 + model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (model.flags.viewSize.height - totalSpacing) / rowsCount
            return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
        }()

        let itemHeights = sectionsRange.map { section -> Int in
            switch model.flags.mode {
            case .all: return itemHeight
            case .section:
                let itemCount = model.flags.itemsPerSection[section]
                let totalPaddingHeight = model.contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = model.flags.viewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int(round(Double(totalAvailableContentHeight) / Double(itemCount)))
            case .emotion:
                return model.flags.viewSize.height - model.contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Section height
        //

        let sectionHeights = sectionsRange.map { section -> Int in
            let itemCount = model.flags.itemsPerSection[section]
            let verticalItemSpacing = (itemCount - 1) * itemSpacing
            let totalItemHeights = itemCount * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max() ?? 0

        //
        // MARK: -
        // MARK: Row header size
        //

        let rowHeaderSize = Size(width: model.headerSize.width, height: maximumSectionHeight)

        //
        // MARK: -
        // MARK: Item width
        //

        let itemWidth: Int = {
            switch model.flags.mode {
            case .all:
                let totalAvailableWidth = model.flags.viewSize.width - model.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * model.flags.numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / model.flags.numberOfColumns
            case .section, .emotion:
                return model.flags.viewSize.width - model.contentPadding * 2
            }
        }()

        //
        // MARK: -
        // MARK: Column header size
        //

        let columnHeaderSize = Size(width: itemWidth, height: model.headerSize.height)

        //
        // MARK: -
        // MARK: Column and row positions
        //

        let rowYPositions = rowsRange.map { row -> Int in
            let cumulativeContentHeight = maximumSectionHeight * row
            let cumulativeSpacingHeight = sectionSpacing.height * row
            let y = columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + model.contentPadding
            switch model.flags.mode {
            case .all:
                return y
            case .section, .emotion:
                return y - sectionSpacing.height - columnHeaderSize.height
            }
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = model.contentPadding + rowHeaderSize.width + sectionSpacing.width
            let x = xPosition + column * (itemWidth + sectionSpacing.width)
            switch model.flags.mode {
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
            let itemsRange = 0..<model.flags.itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = item * itemSpacing
                let cumulativeContentHeight = item * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let itemsRange = 0..<model.flags.itemsPerSection[section]
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
            switch model.flags.mode {
            case .all:
                return nil
            case .section(let section, _):
                let column = columnIndex(forSection: section)
                let x = columnXPositions[column] - model.contentPadding
                let row = rowIndex(forSection: section)
                let y = rowYPositions[row] - model.contentPadding - model.flags.topContentInset
                return Point(x: x, y: y + model.flags.topContentInset)
            case .emotion(let indexPath, _):
                let column = columnIndex(forSection: indexPath.section)
                let x = columnXPositions[column] - model.contentPadding
                let y = yPositionsForItems[indexPath.section][indexPath.item] - model.contentPadding - model.flags.topContentInset
                return Point(x: x, y: y + model.flags.topContentInset)
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
            for item in 0..<model.flags.itemsPerSection[section] {
                let position = itemPositions[section][item] - proposedContentOffset
                let alpha: Float
                switch model.flags.mode {
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
            switch model.flags.mode {
            case .all: y = model.contentPadding
            case .section, .emotion: y = -columnHeaderSize.height
            }
            return .init(x: x, y: y) - proposedContentOffset
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let x: Int
            switch model.flags.mode {
            case .all: x = model.contentPadding
            case .section, .emotion: x = -rowHeaderSize.width
            }
            let y = rowYPositions[row]
            return .init(x: x, y: y) - proposedContentOffset
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaders: [IndexPath: Header] = columnsRange.reduce([:]) { headers, column in
            let position = positionsForColumnHeaders[column]
            let frame = Rect(origin: position, size: columnHeaderSize)
            let alpha: Float
            switch model.flags.mode {
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
            switch model.flags.mode {
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
            switch model.flags.mode {
            case .all:
                let isCompact = model.flags.viewSize.height >= model.minViewHeightForCompactLayout
                if isCompact { return model.flags.viewSize }
            case .section, .emotion:
                return model.flags.viewSize
            }

            let lastColumnIndexPath = IndexPath(section: model.flags.numberOfColumns - 1)
            let lastRowIndexPath = IndexPath(section: rowsCount - 1)
            let lastColumnHeaderFrame = columnHeaders[lastColumnIndexPath]!.frame
            let lastRowHeaderFrame = rowHeaders[lastRowIndexPath]!.frame

            let width = lastColumnHeaderFrame.maxX + model.contentPadding
            let height = lastRowHeaderFrame.maxY + model.contentPadding
            return .init(width: width, height: height)
        }()

        return View(
            chartSize: chartSize,
            items: items,
            columnHeaders: columnHeaders,
            rowHeaders: rowHeaders
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

    static func - (lhs: Point, rhs: Point?) -> Point {
        guard let rhs = rhs else { return lhs }
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return .init(x: x, y: y)
    }

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
