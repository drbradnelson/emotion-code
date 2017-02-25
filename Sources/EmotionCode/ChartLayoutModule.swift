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
    }

    struct Model {
        var mode: Mode
        let itemsPerSection: [Int]
        let numberOfColumns: Int
        let topContentInset: Int
        let bottomContentInset: Int
        let viewSize: Size

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
        case invalidAmountOfItems
        case invalidNumberOfColumns
        case invalidViewSize
        case invalidMode
    }

    public static func start(with flags: Flags, perform: (Command) -> Void) throws -> Model {
        guard flags.numberOfColumns > 0 else {
            throw Failure.invalidNumberOfColumns
        }
        for items in flags.itemsPerSection {
            guard items >= 0 else {
                throw Failure.invalidAmountOfItems
            }
        }
        guard flags.itemsPerSection.reduce(0, +) > 0 else {
            throw Failure.missingItems
        }
        guard flags.viewSize.width > 0, flags.viewSize.height > 0 else {
            throw Failure.invalidViewSize
        }
        return Model(
            mode: flags.mode,
            itemsPerSection: flags.itemsPerSection,
            numberOfColumns: flags.numberOfColumns,
            topContentInset: flags.topContentInset,
            bottomContentInset: flags.bottomContentInset,
            viewSize: flags.viewSize
        )
    }

    static func update(for message: Message, model: inout Model, perform: (Command) -> Void) throws {
        switch message {
        case .viewWillTransition:
            switch model.mode {
            case .all:
                throw Failure.invalidMode
            case .section(let section, _):
                model.mode = .section(section, isFocused: false)
            case .emotion(let emotion, _):
                model.mode = .emotion(emotion, isFocused: false)
            }
        case .viewDidTransition:
            switch model.mode {
            case .all:
                throw Failure.invalidMode
            case .section(let section, _):
                model.mode = .section(section, isFocused: true)
            case .emotion(let emotion, _):
                model.mode = .emotion(emotion, isFocused: true)
            }
        }
    }

    static func view(for model: Model) throws -> View {

        func rowIndex(forSection section: Int) -> Int {
            return section / model.numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return section % model.numberOfColumns
        }

        let sectionsCount = model.itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<model.numberOfColumns
        let rowsCount = Int(round(Double(sectionsCount) / Double(model.numberOfColumns)))
        let rowsRange = 0..<rowsCount

        let visibleViewSize = Size(
            width: model.viewSize.width,
            height: model.viewSize.height - model.topContentInset - model.bottomContentInset
        )

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch model.mode {
            case .all:
                return model.sectionSpacing
            case .section, .emotion:
                let width = model.contentPadding * 2
                let height = model.contentPadding + max(model.topContentInset, model.bottomContentInset)
                return .init(width: width, height: height)
            }
        }()

        let itemSpacing: Int = {
            switch model.mode {
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
                visibleViewSize.height >= model.minViewHeightForCompactLayout,
                let maximumItemsCountInSection = model.itemsPerSection.max() else { return model.itemHeight }
            let totalSpacing = model.contentPadding * 2 + model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (visibleViewSize.height - totalSpacing) / rowsCount
            return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
        }()

        let itemHeights = sectionsRange.map { section -> Int in
            switch model.mode {
            case .all: return itemHeight
            case .section:
                let itemCount = model.itemsPerSection[section]
                let totalPaddingHeight = model.contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = visibleViewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int(round(Double(totalAvailableContentHeight) / Double(itemCount)))
            case .emotion:
                return visibleViewSize.height - model.contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Section height
        //

        let sectionHeights = sectionsRange.map { section -> Int in
            let itemCount = model.itemsPerSection[section]
            let verticalItemSpacing = (itemCount - 1) * itemSpacing
            let totalItemHeights = itemCount * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max()!

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
            switch model.mode {
            case .all:
                let totalAvailableWidth = visibleViewSize.width - model.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * model.numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / model.numberOfColumns
            case .section, .emotion:
                return visibleViewSize.width - model.contentPadding * 2
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
            switch model.mode {
            case .all:
                return y
            case .section, .emotion:
                return y - sectionSpacing.height - columnHeaderSize.height
            }
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = model.contentPadding + rowHeaderSize.width + sectionSpacing.width
            let x = xPosition + column * (itemWidth + sectionSpacing.width)
            switch model.mode {
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
            let itemsRange = 0..<model.itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = item * itemSpacing
                let cumulativeContentHeight = item * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let itemsRange = 0..<model.itemsPerSection[section]
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
            switch model.mode {
            case .all:
                return nil
            case .section(let section, _):
                let column = columnIndex(forSection: section)
                let x = columnXPositions[column] - model.contentPadding
                let row = rowIndex(forSection: section)
                let y = rowYPositions[row] - model.contentPadding - model.topContentInset
                return Point(x: x, y: y + model.topContentInset)
            case .emotion(let indexPath, _):
                let column = columnIndex(forSection: indexPath.section)
                let x = columnXPositions[column] - model.contentPadding
                let y = yPositionsForItems[indexPath.section][indexPath.item] - model.contentPadding - model.topContentInset
                return Point(x: x, y: y + model.topContentInset)
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
            for item in 0..<model.itemsPerSection[section] {
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
                switch model.mode {
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
            switch model.mode {
            case .all: y = model.contentPadding
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
            switch model.mode {
            case .all: x = model.contentPadding
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
            switch model.mode {
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
            switch model.mode {
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
            switch model.mode {
            case .all:
                let isCompact = visibleViewSize.height >= model.minViewHeightForCompactLayout
                if isCompact { return visibleViewSize }
            case .section, .emotion:
                return visibleViewSize
            }

            let lastColumnIndexPath = IndexPath(section: model.numberOfColumns - 1)
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
