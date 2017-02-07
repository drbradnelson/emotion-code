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
    }

    enum Mode {
        case all
        case section(Int)
        case emotion(IndexPath)
    }

    enum Message {
        case systemDidSetViewSize(Size)
        case scrollViewWillEndDragging(at: Point, velocity: Point)
    }

    enum ScrollDirection {
        case right
        case left
        case down
        case up
        case crazy
        case none
    }

    struct Model {
        let flags: Flags
        let minViewHeightForCompactLayout = 554
        let headerSize = Size(width: 30, height: 30)
        let itemHeight = 30
        let contentPadding = 10
        let sectionSpacing = Size(width: 5, height: 5)
        let itemSpacing = 10
        var viewSize: Size?
    }

    enum Command {
        case setSection(Int)
    }

    struct View {
        let chartSize: Size
        let proposedContentOffset: Point?
        let itemFrames: [[Rect]]
        let columnHeaderFrames: [Rect]
        let rowHeaderFrames: [Rect]
        let isScrollEnabled: Bool
    }

    enum Failure: Error {
        case missingItems
        case missingViewSize
        case invalidNumberOfColums
        case invalidViewSize
        case invalidMode
        case invalidVelocity
    }

    static func model(loading flags: Flags) throws -> Model {
        guard flags.numberOfColumns > 0 else {
            throw Failure.invalidNumberOfColums
        }
        guard !flags.itemsPerSection.isEmpty else {
            throw Failure.missingItems
        }
        return Model(flags: flags, viewSize: nil)
    }

    static func update(for message: Message, model: inout Model, perform: (Command) -> Void) throws {
        switch message {
        case .systemDidSetViewSize(let size):
            guard size.width > 0, size.height > 0 else {
                throw Failure.invalidViewSize
            }
            model.viewSize = size
        case .scrollViewWillEndDragging(let contentOffset, let velocity):
            guard case .section(let currentSection) = model.flags.mode else {
                throw Failure.invalidMode
            }
            guard let viewSize = model.viewSize else {
                throw Failure.missingViewSize
            }
            let proposedContentOffset = try! view(presenting: model).proposedContentOffset!

            let scrollDirection: ScrollDirection = {
                let isScrolling = (
                    horizontally: contentOffset.x != proposedContentOffset.x,
                    vertically: contentOffset.y != proposedContentOffset.y
                )
                if isScrolling.horizontally && isScrolling.vertically {
                    return .crazy
                }
                if contentOffset.x > proposedContentOffset.x {
                    return .right
                }
                if contentOffset.x < proposedContentOffset.x {
                    return .left
                }
                if contentOffset.y > proposedContentOffset.y {
                    return .down
                }
                if contentOffset.y < proposedContentOffset.y {
                    return .up
                }
                return .none
            }()

            let overHalf: Bool
            let canScroll: Bool
            switch scrollDirection {
            case .right:
                canScroll = velocity.x > 0
                overHalf = contentOffset.x >= (proposedContentOffset.x + viewSize.width / 2)
            case .left:
                canScroll = velocity.x < 0
                overHalf = contentOffset.x <= (proposedContentOffset.x - viewSize.width / 2)
            case .down:
                canScroll = velocity.y > 0
                overHalf = contentOffset.y >= (proposedContentOffset.y + viewSize.height / 2)
            case .up:
                canScroll = velocity.y < 0
                overHalf = contentOffset.y <= (proposedContentOffset.y - viewSize.height / 2)
            case .crazy, .none:
                canScroll = false
                overHalf = false
            }
            guard canScroll || overHalf && (velocity == .zero) else { return }

            let currentColumn = (currentSection + model.flags.numberOfColumns) % model.flags.numberOfColumns
            let currentRow = currentSection / model.flags.numberOfColumns

            func sectionIndex(forRow row: Int, forColumn column: Int) -> Int? {
                let section = row * model.flags.numberOfColumns + column
                guard section < model.flags.itemsPerSection.count else { return nil }
                return section
            }

            let newSection: Int?
            switch scrollDirection {
            case .right:
                guard currentColumn + 1 < model.flags.numberOfColumns else { return }
                newSection = sectionIndex(forRow: currentRow, forColumn: currentColumn + 1)
            case .left:
                guard currentColumn - 1 >= 0 else { return }
                newSection = sectionIndex(forRow: currentRow, forColumn: currentColumn - 1)
            case .up:
                guard currentRow - 1 >= 0 else { return }
                newSection = sectionIndex(forRow: currentRow - 1, forColumn: currentColumn)
            case .down:
                newSection = sectionIndex(forRow: currentRow + 1, forColumn: currentColumn)
            case .crazy, .none:
                return
            }
            guard let section = newSection else { return }

            perform(.setSection(section))
            model = Model(
                flags: Flags(
                    mode: .section(section),
                    itemsPerSection: model.flags.itemsPerSection,
                    numberOfColumns: model.flags.numberOfColumns,
                    topContentInset: model.flags.topContentInset
                ),
                viewSize: model.viewSize
            )
        }
    }


    static func view(presenting model: Model) throws -> View {

        guard let viewSize = model.viewSize else {
            throw Failure.missingViewSize
        }

        // We're only rounding itemHeight and itemHeights to closest values

        func rowIndex(forSection section: Int) -> Int {
            return section / model.flags.numberOfColumns
        }

        func columnIndex(forSection section: Int) -> Int {
            return (section + model.flags.numberOfColumns) % model.flags.numberOfColumns
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
            case .all: return model.sectionSpacing
            case .section, .emotion: return .init(width: model.contentPadding * 2, height: model.contentPadding * 2)
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
                viewSize.height >= model.minViewHeightForCompactLayout,
                let maximumItemsCountInSection = model.flags.itemsPerSection.max() else { return model.itemHeight }
            let totalSpacing = model.contentPadding * 2 + model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (viewSize.height - totalSpacing) / rowsCount
            return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
        }()

        let itemHeights = sectionsRange.map { section -> Int in
            switch model.flags.mode {
            case .all: return itemHeight
            case .section:
                let itemCount = model.flags.itemsPerSection[section]
                let totalPaddingHeight = model.contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = viewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int(round(Double(totalAvailableContentHeight) / Double(itemCount)))
            case .emotion:
                return viewSize.height - model.contentPadding * 2
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
                let totalAvailableWidth = viewSize.width - model.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * model.flags.numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / model.flags.numberOfColumns
            case .section, .emotion:
                return viewSize.width - model.contentPadding * 2
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
            let column = (section + model.flags.numberOfColumns) % model.flags.numberOfColumns
            let xPosition = columnXPositions[column]

            let itemsRange = 0..<model.flags.itemsPerSection[section]
            return itemsRange.map { item in
                let yPosition = yPositionsForItems[section][item]
                return Point(x: xPosition, y: yPosition)
            }
        }

        //
        // MARK: -
        // MARK: Item frame
        //

        let itemFrames = sectionsRange.map { section -> [Rect] in
            let height = itemHeights[section]
            let size = Size(width: itemWidth, height: height)
            let itemsRange = 0..<model.flags.itemsPerSection[section]
            return itemsRange.map { item in
                let position = itemPositions[section][item]
                return Rect(origin: position, size: size)
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
            case .section(let section):
                let column = columnIndex(forSection: section)
                let x = columnXPositions[column] - model.contentPadding
                let row = rowIndex(forSection: section)
                let y = rowYPositions[row] - model.contentPadding - model.flags.topContentInset
                return Point(x: x, y: y)
            case .emotion(let indexPath):
                let column = columnIndex(forSection: indexPath.section)
                let x = columnXPositions[column] - model.contentPadding
                let y = yPositionsForItems[indexPath.section][indexPath.item] - model.contentPadding - model.flags.topContentInset
                return Point(x: x, y: y)
            }
        }()

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
            return Point(x: x, y: y)
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let y = rowYPositions[row]
            let x: Int
            switch model.flags.mode {
            case .all: x = model.contentPadding
            case .section, .emotion: x = -rowHeaderSize.width
            }
            return Point(x: x, y: y)
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaderFrames = sectionsRange.map { section -> Rect in
            let column = (section + model.flags.numberOfColumns) % model.flags.numberOfColumns
            let position = positionsForColumnHeaders[column]
            return Rect(origin: position, size: columnHeaderSize)
        }

        let rowHeaderFrames = sectionsRange.map { section -> Rect in
            let row = section / model.flags.numberOfColumns
            let position = positionsForRowHeaders[row]
            return Rect(origin: position, size: rowHeaderSize)
        }

        //
        // MARK: -
        // MARK: Chart size
        //

        let chartSize: Size = {
            guard
                let lastRowHeaderFrame = rowHeaderFrames.last,
                let lastColumnHeaderFrame = columnHeaderFrames.last else { return viewSize }
            let height = lastRowHeaderFrame.maxY + model.contentPadding
            let width = lastColumnHeaderFrame.maxX + model.contentPadding
            return Size(width: width, height: height)
        }()

        //
        // MARK: -
        // MARK: Is scroll enabled
        //

        let isScrollEnabled: Bool = {
            switch model.flags.mode {
            case .all:
                return viewSize.height < model.minViewHeightForCompactLayout
            case .section:
                return true
            case .emotion:
                return false
            }
        }()

        return View(
            chartSize: chartSize,
            proposedContentOffset: proposedContentOffset,
            itemFrames: itemFrames,
            columnHeaderFrames: columnHeaderFrames,
            rowHeaderFrames: rowHeaderFrames,
            isScrollEnabled: isScrollEnabled
        )

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

    static var zero: Point {
        return .init(x: 0, y: 0)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }

}

public struct Size {

    var width: Int
    var height: Int

    static var zero: Size {
        return .init(width: 0, height: 0)
    }

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
