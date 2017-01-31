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
        case setViewSize(Size)
        case updateWithVelocity(Point)
    }

    enum ScrollDirection {
        case right
        case left
        case down
        case up
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

    enum Command {}

    struct View {
        let chartSize: Size
        let proposedContentOffset: Point?
        let itemFrames: [[Rect]]
        let columnHeaderFrames: [Rect]
        let rowHeaderFrames: [Rect]
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
        case .setViewSize(let size):
            guard size.width > 0, size.height > 0 else {
                throw Failure.invalidViewSize
            }
            model.viewSize = size
        case .updateWithVelocity(let velocity):
            guard case .section(let currentSection) = model.flags.mode else {
                throw Failure.invalidMode
            }
            // Check if user is scrolling in vertical or horizontal only
            guard !(velocity.x != 0 && velocity.y != 0) && (velocity.x != 0 || velocity.y != 0) else {
                return
            }
            let scrollDirection: ScrollDirection = try! {
                if velocity.x > 0 {
                    return .right
                }
                if velocity.x < 0 {
                    return .left
                }
                if velocity.y > 0 {
                    return .down
                }
                if velocity.y < 0 {
                    return .up
                }
                throw Failure.invalidVelocity
            }()

            let currentColumn = (currentSection + model.flags.numberOfColumns) % model.flags.numberOfColumns
            let currentRow = currentSection / model.flags.numberOfColumns

            func sectionIndex(forRow row: Int, forColumn column: Int) -> Int {
                return row * model.flags.numberOfColumns + column
            }

            // Very messy, need to rewrite this
            let newSection: Int
            switch scrollDirection {
            case .right:
                let newColumn = currentColumn + 1
                guard newColumn < model.flags.numberOfColumns else { return }
                newSection = sectionIndex(forRow: currentRow, forColumn: newColumn)
            case .left:
                let newColumn = currentColumn - 1
                guard newColumn >= 0 else { return }
                newSection = sectionIndex(forRow: currentRow, forColumn: newColumn)
            case .up:
                let newRow = currentRow - 1
                guard newRow >= 0 else { return }
                newSection = sectionIndex(forRow: newRow, forColumn: currentColumn)
            case .down:
                let newRow = currentRow + 1
                let numberOfRows = Int(round(Double(model.flags.itemsPerSection.count) / Double(model.flags.numberOfColumns)))
                guard newRow < numberOfRows else { return }
                newSection = sectionIndex(forRow: newRow, forColumn: currentColumn)
            }

            model = Model(
                flags: Flags(
                    mode: .section(newSection),
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
            case .section, .emotion: return Size(width: model.contentPadding, height: model.contentPadding)
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
                return y - model.contentPadding - columnHeaderSize.height
            }
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = model.contentPadding + rowHeaderSize.width + sectionSpacing.width
            let x = xPosition + column * (itemWidth + sectionSpacing.width)
            switch model.flags.mode {
            case .all:
                return x
            case .section, .emotion:
                return x - model.contentPadding - rowHeaderSize.width
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

        return View(
            chartSize: chartSize,
            proposedContentOffset: proposedContentOffset,
            itemFrames: itemFrames,
            columnHeaderFrames: columnHeaderFrames,
            rowHeaderFrames: rowHeaderFrames
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

}

public struct Size {

    var width: Int
    var height: Int

    static var zero: Size {
        return Size(width: 0, height: 0)
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
