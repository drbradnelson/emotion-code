import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable cyclomatic_complexity

struct ChartLayoutModule: Elm.Module {

    enum Mode {
        case all
        case section(Int)
        case emotion(IndexPath)
    }

    enum Message {
        case setMode(Mode)
        case setItemsPerSection([Int])
        case setViewSize(Size)
        case setNumberOfColumns(Int)
    }

    struct Model: Initable {

        var mode = Mode.all
        var itemsPerSection: [Int] = []
        var viewSize: Size = .zero
        var numberOfColumns = 2

        var minViewHeightForCompactLayout = 554
        var headerSize = Size(width: 30, height: 30)
        var itemHeight = 30
        var contentPadding = 10
        var sectionSpacing = Size(width: 5, height: 5)
        var itemSpacing = 10

    }

    typealias Command = Void

    struct View {
        let chartSize: Size
        let proposedVerticalContentOffset: Int?
        let itemFrames: [[Rect]]
        let columnHeaderFrames: [Rect]
        let rowHeaderFrames: [Rect]
    }

    enum Failure: Error {
        case missingItems
        case negativeNumberOfColumns
        case zeroNumberOfColumns
        case negativeViewSize
        case zeroViewSize
    }

    static func update(for message: Message, model: inout Model) throws -> [Command] {
        switch message {
        case .setMode(let mode):
            model.mode = mode
        case .setItemsPerSection(let itemsPerSection):
            guard !itemsPerSection.isEmpty else { throw Failure.missingItems }
            model.itemsPerSection = itemsPerSection
        case .setViewSize(let size):
            guard size.width != 0, size.height != 0 else { throw Failure.zeroViewSize }
            guard size.width > 0, size.height > 0 else { throw Failure.negativeViewSize }
            model.viewSize = size
        case .setNumberOfColumns(let numberOfColumns):
            guard numberOfColumns != 0 else { throw Failure.zeroNumberOfColumns }
            guard numberOfColumns > 0 else { throw Failure.negativeNumberOfColumns }
            model.numberOfColumns = numberOfColumns
        }
        return []
    }

    static func view(for model: Model) -> View {

        func rowIndex(forSection section: Int) -> Int {
            return section / model.numberOfColumns
        }

        let sectionsCount = model.itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<model.numberOfColumns
        let rowsCount = Int((Double(sectionsCount) / Double(model.numberOfColumns)).rounded())
        let rowsRange = 0..<rowsCount

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch model.mode {
            case .all: return model.sectionSpacing
            case .section, .emotion: return Size(width: model.contentPadding, height: model.contentPadding)
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
                model.viewSize.height >= model.minViewHeightForCompactLayout,
                let maximumItemsCountInSection = model.itemsPerSection.max() else { return model.itemHeight }
            let totalSpacing = model.contentPadding * 2 + model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (model.viewSize.height - totalSpacing) / rowsCount
            return Int((Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)).rounded())
        }()

        let itemHeights = sectionsRange.map { section -> Int in
            switch model.mode {
            case .all: return itemHeight
            case .section:
                let itemCount = model.itemsPerSection[section]
                let totalPaddingHeight = model.contentPadding * 2
                let totalSpacingHeight = itemSpacing * (itemCount - 1)
                let totalAvailableContentHeight = model.viewSize.height - totalPaddingHeight - totalSpacingHeight
                return Int((Double(totalAvailableContentHeight) / Double(itemCount)).rounded())
            case .emotion:
                return model.viewSize.height - model.contentPadding * 2
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
            switch model.mode {
            case .all:
                let totalAvailableWidth = model.viewSize.width - model.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * model.numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / model.numberOfColumns
            case .section, .emotion:
                return model.viewSize.width - model.contentPadding * 2
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
            return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + model.contentPadding
        }

        let columnXPositions = columnsRange.map { column -> Int in
            let xPosition = model.contentPadding + rowHeaderSize.width + sectionSpacing.width
            return xPosition + column * (itemWidth + sectionSpacing.width)
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
            let column = (section + model.numberOfColumns) % model.numberOfColumns
            let xPosition = columnXPositions[column]

            let itemsRange = 0..<model.itemsPerSection[section]
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
            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let position = itemPositions[section][item]
                return Rect(origin: position, size: size)
            }
        }

        //
        // MARK: -
        // MARK: Content offset
        //

        let proposedVerticalContentOffset: Int? = {
            switch model.mode {
            case .all:
                return nil
            case .section(let section):
                let row = rowIndex(forSection: section)
                return rowYPositions[row] - model.contentPadding
            case .emotion(let indexPath):
                return yPositionsForItems[indexPath.section][indexPath.item] - model.contentPadding
            }
        }()

        //
        // MARK: -
        // MARK: Header position
        //

        let positionsForColumnHeaders = columnsRange.map { column -> Point in
            let x = columnXPositions[column]
            let y: Int
            switch model.mode {
            case .all: y = model.contentPadding
            case .section, .emotion: y = model.contentPadding - columnHeaderSize.height
            }
            return Point(x: x, y: y)
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let y = rowYPositions[row]
            let x: Int
            switch model.mode {
            case .all: x = model.contentPadding
            case .section, .emotion: x = model.contentPadding - rowHeaderSize.width
            }
            return Point(x: x, y: y)
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaderFrames = columnsRange.map { column -> Rect in
            let position = positionsForColumnHeaders[column]
            return Rect(origin: position, size: columnHeaderSize)
        }

        let rowHeaderFrames = rowsRange.map { row -> Rect in
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
                let lastColumnHeaderFrame = columnHeaderFrames.last else { return model.viewSize }
            let height = lastRowHeaderFrame.maxY + model.contentPadding
            let width = lastColumnHeaderFrame.maxX + model.contentPadding
            return Size(width: width, height: height)
        }()

        return View(
            chartSize: chartSize,
            proposedVerticalContentOffset: proposedVerticalContentOffset,
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
