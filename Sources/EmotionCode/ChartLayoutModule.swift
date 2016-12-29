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
        case setTopContentInset(Int)
    }

    struct Model: Initable {

        var mode: Mode?
        var itemsPerSection: [Int]?
        var viewSize: Size?
        var numberOfColumns: Int?
        var topContentInset: Int?

        let minViewHeightForCompactLayout = 554
        let headerSize = Size(width: 30, height: 30)
        let itemHeight = 30
        let contentPadding = 10
        let sectionSpacing = Size(width: 5, height: 5)
        let itemSpacing = 10

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
        case missingMode
        case missingItems
        case missingViewSize
        case missingNumberOfColumns
        case missingTopContentInset

        case zeroViewSize
        case negativeViewSize
        case zeroNumberOfColumns
        case negativeNumberOfColumns
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
        case .setTopContentInset(let topContentInset):
            model.topContentInset = topContentInset
        }
        return []
    }

    static func view(for model: Model) throws -> View {

        guard let mode = model.mode else { throw Failure.missingMode }
        guard let itemsPerSection = model.itemsPerSection else { throw Failure.missingItems }
        guard let viewSize = model.viewSize else { throw Failure.missingViewSize }
        guard let numberOfColumns = model.numberOfColumns else { throw Failure.missingNumberOfColumns }
        guard let topContentInset = model.topContentInset else { throw Failure.missingTopContentInset }


        // We're only rounding itemHeight and itemHeights to closest values

        func rowIndex(forSection section: Int) -> Int {
            return section / numberOfColumns
        }

        let sectionsCount = itemsPerSection.count
        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<numberOfColumns
        let rowsCount = Int(round(Double(sectionsCount) / Double(numberOfColumns)))
        let rowsRange = 0..<rowsCount

        //
        // MARK: -
        // MARK: Section and item spacing
        //

        let sectionSpacing: Size = {
            switch mode {
            case .all: return model.sectionSpacing
            case .section, .emotion: return Size(width: model.contentPadding, height: model.contentPadding)
            }
        }()

        let itemSpacing: Int = {
            switch mode {
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
                let maximumItemsCountInSection = itemsPerSection.max() else { return model.itemHeight }
            let totalSpacing = model.contentPadding * 2 + model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (viewSize.height - totalSpacing) / rowsCount
            return Int(round(Double(totalAvailableSpacePerSection) / Double(maximumItemsCountInSection)))
        }()

        let itemHeights = sectionsRange.map { section -> Int in
            switch mode {
            case .all: return itemHeight
            case .section:
                let itemCount = itemsPerSection[section]
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
            let itemCount = itemsPerSection[section]
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
            switch mode {
            case .all:
                let totalAvailableWidth = viewSize.width - model.contentPadding * 2 - rowHeaderSize.width
                let totalSpacingWidth = sectionSpacing.width * numberOfColumns
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / numberOfColumns
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
            let itemsRange = 0..<itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = item * itemSpacing
                let cumulativeContentHeight = item * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let column = (section + numberOfColumns) % numberOfColumns
            let xPosition = columnXPositions[column]

            let itemsRange = 0..<itemsPerSection[section]
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
            let itemsRange = 0..<itemsPerSection[section]
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
            switch mode {
            case .all:
                return nil
            case .section(let section):
                let row = rowIndex(forSection: section)
                return rowYPositions[row] - model.contentPadding - topContentInset
            case .emotion(let indexPath):
                return yPositionsForItems[indexPath.section][indexPath.item] - model.contentPadding - topContentInset
            }
        }()

        //
        // MARK: -
        // MARK: Header position
        //

        let positionsForColumnHeaders = columnsRange.map { column -> Point in
            let x = columnXPositions[column]
            let y: Int
            switch mode {
            case .all: y = model.contentPadding
            case .section, .emotion: y = model.contentPadding - columnHeaderSize.height
            }
            return Point(x: x, y: y)
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let y = rowYPositions[row]
            let x: Int
            switch mode {
            case .all: x = model.contentPadding
            case .section, .emotion: x = model.contentPadding - rowHeaderSize.width
            }
            return Point(x: x, y: y)
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaderFrames = sectionsRange.map { section -> Rect in
            let column = (section + numberOfColumns) % numberOfColumns
            let position = positionsForColumnHeaders[column]
            return Rect(origin: position, size: columnHeaderSize)
        }

        let rowHeaderFrames = sectionsRange.map { section -> Rect in
            let row = section / numberOfColumns
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
