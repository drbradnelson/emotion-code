import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable function_body_length
// swiftlint:disable file_length
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
    }

    struct Model: Initable {
        var mode = Mode.all
        var itemsPerSection: [Int] = []
        var viewSize: Size = .zero
        static let headerSize = Size(width: 30, height: 30)
        static let baseItemHeight: Float = 30
        static let minViewHeightForCompactLayout: Float = 554
    }

    typealias Command = Void

    struct View {
        let chartSize: Size
        let proposedVerticalContentOffset: Float?
        let itemFrames: [[Rect]]
        let columnHeaderFrames: [Rect]
        let rowHeaderFrames: [Rect]
        static let numberOfColumns = 2
    }

    enum Failure: Error {
        case emptyItemsPerSectionArray
        case negativeViewSize
        case zeroViewSize

        case viewSizeSmallerThanSectionSpacing
        case viewSizeSmallerThanContentPadding
        case viewSizeSmallerThanHeaderSize
        case viewWidthSmallerThanAllSpacingAndRowHeaderWidth
    }

    static func update(for message: Message, model: inout Model) throws -> [Command] {
        switch message {
        case .setMode(let mode):
            model.mode = mode
        case .setItemsPerSection(let itemsPerSection):
            guard !itemsPerSection.isEmpty else { throw Failure.emptyItemsPerSectionArray }
            model.itemsPerSection = itemsPerSection
        case .setViewSize(let size):
            guard size.width != 0, size.height != 0 else { throw Failure.zeroViewSize }
            guard size.width > 0, size.height > 0 else { throw Failure.negativeViewSize }
            model.viewSize = size
        }
        return []
    }

    static func view(for model: Model) throws -> View {

        let sectionsCount = model.itemsPerSection.count

        guard sectionsCount > 0 else {
            return View(
                chartSize: .zero,
                proposedVerticalContentOffset: nil,
                itemFrames: [],
                columnHeaderFrames: [],
                rowHeaderFrames: []
            )
        }

        func rowIndex(forSection section: Int) -> Int {
            return section / View.numberOfColumns
        }

        let sectionsRange = 0..<sectionsCount
        let columnsRange = 0..<View.numberOfColumns
        let rowsCount = (Float(sectionsCount) / Float(View.numberOfColumns)).rounded(.up)
        let rowsRange = 0..<Int(rowsCount)

        //
        // MARK: -
        // MARK: Spacing & padding
        //


        var contentPadding: Float {
            switch model.mode {
            case .all: return 10
            case .section, .emotion: return 20
            }
        }

        var sectionSpacing: Size {
            switch model.mode {
            case .all: return Size(width: 5, height: 5)
            case .section, .emotion: return Size(width: contentPadding, height: contentPadding)
            }
        }

        guard model.viewSize.width > sectionSpacing.width, model.viewSize.height > sectionSpacing.height else {
            throw Failure.viewSizeSmallerThanSectionSpacing

        }

        guard model.viewSize.width > contentPadding, model.viewSize.height > contentPadding else {
            throw Failure.viewSizeSmallerThanContentPadding
        }

        var itemSpacing: Float {
            switch model.mode {
            case .all: return 0
            case .section: return 10
            case .emotion: return sectionSpacing.height
            }
        }

        guard model.viewSize.width > Model.headerSize.width, model.viewSize.height > Model.headerSize.height else {
            throw Failure.viewSizeSmallerThanHeaderSize
        }

        guard model.viewSize.width > (contentPadding * 2 + sectionSpacing.width * Float(View.numberOfColumns) + Model.headerSize.width) else {
            throw Failure.viewWidthSmallerThanAllSpacingAndRowHeaderWidth
        }

        //
        // MARK: -
        // MARK: Item heights
        //

        var baseItemHeight: Float {
            guard model.viewSize.height >= Model.minViewHeightForCompactLayout else { return Model.baseItemHeight }

            let totalSpacing = contentPadding * 2 + Model.headerSize.height + sectionSpacing.height * rowsCount
            let totalAvailableSpacePerSection = (model.viewSize.height - totalSpacing) / rowsCount
            let maximumItemsCountInSection = model.itemsPerSection.max()!
            return totalAvailableSpacePerSection / Float(maximumItemsCountInSection)
        }

        let itemHeights = sectionsRange.map { section -> Float in
            switch model.mode {
            case .all: return baseItemHeight
            case .section:
                let itemCount = model.itemsPerSection[section]
                let totalPaddingHeight = contentPadding * 2
                let totalSpacingHeight = itemSpacing * Float(itemCount - 1)
                let totalAvailableContentHeight = model.viewSize.height - totalPaddingHeight - totalSpacingHeight
                return totalAvailableContentHeight / Float(itemCount)
            case .emotion:
                let totalPaddingHeight = contentPadding * 2
                let totalAvailableContentHeight = model.viewSize.height - totalPaddingHeight
                return totalAvailableContentHeight
            }
        }

        //
        // MARK: -
        // MARK: Section height
        //

        let sectionHeights = sectionsRange.map { section -> Float in
            let itemCount = model.itemsPerSection[section]
            let verticalItemSpacing = Float(itemCount - 1) * itemSpacing
            let totalItemHeights = Float(itemCount) * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max() ?? 0

        //
        // MARK: -
        // MARK: Row header size
        //

        let rowHeaderSize = Size(width: Model.headerSize.width, height: maximumSectionHeight)

        //
        // MARK: -
        // MARK: Item width
        //

        var itemWidth: Float {
            switch model.mode {
            case .all:
                let totalAvailableWidth = model.viewSize.width - contentPadding * 2 - rowHeaderSize.width - sectionSpacing.width
                let totalSpacingWidth = sectionSpacing.width * Float(View.numberOfColumns - 1)
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / Float(View.numberOfColumns)
            case .section, .emotion:
                return model.viewSize.width - contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Column header size
        //

        let columnHeaderSize = Size(width: itemWidth, height: Model.headerSize.height)

        //
        // MARK: -
        // MARK: Column and row positions
        //

        let rowYPositions = rowsRange.map { row -> Float in
            let cumulativeContentHeight = maximumSectionHeight * Float(row)
            let cumulativeSpacingHeight = sectionSpacing.height * Float(row)
            return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + contentPadding
        }

        let columnXPositions = columnsRange.map { column -> Float in
            let xPosition = contentPadding + rowHeaderSize.width + sectionSpacing.width
            return xPosition + Float(column) * (itemWidth + sectionSpacing.width)
        }

        //
        // MARK: -
        // MARK: Item position
        //

        let yPositionsForItems = sectionsRange.map { section -> [Float] in
            let itemsRange = 0..<model.itemsPerSection[section]
            let row = rowIndex(forSection: section)

            return itemsRange.map { item in
                let cumulativeSpacingHeight = Float(item) * itemSpacing
                let cumulativeContentHeight = Float(item) * itemHeights[section]
                return rowYPositions[row] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let column = (section + ChartLayoutModule.View.numberOfColumns) % ChartLayoutModule.View.numberOfColumns
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

        var proposedVerticalContentOffset: Float? {
            switch model.mode {
            case .all:
                return nil
            case .section(let section):
                let row = rowIndex(forSection: section)
                return rowYPositions[row] - sectionSpacing.height
            case .emotion(let indexPath):
                return yPositionsForItems[indexPath.section][indexPath.item] - sectionSpacing.height
            }
        }

        //
        // MARK: -
        // MARK: Header position
        //

        let positionsForColumnHeaders = columnsRange.map { column -> Point in
            let x = columnXPositions[column]

            let y: Float
            switch model.mode {
            case .all: y = contentPadding
            case .section, .emotion: y = contentPadding - columnHeaderSize.height
            }

            return Point(x: x, y: y)
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let y = rowYPositions[row]

            let x: Float
            switch model.mode {
            case .all: x = contentPadding
            case .section, .emotion: x = contentPadding - rowHeaderSize.width
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

        var chartSize: Size {
            guard
                let lastRowHeaderFrame = rowHeaderFrames.last,
                let lastColumnHeaderFrame = columnHeaderFrames.last else { return .zero }

            let height = lastRowHeaderFrame.maxY + contentPadding
            let width = lastColumnHeaderFrame.maxX + contentPadding
            return Size(width: width, height: height)
        }

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
    let x: Float

    // swiftlint:disable:next variable_name
    let y: Float

}

public struct Size {

    let width: Float
    let height: Float

    static var zero: Size {
        return Size(width: 0, height: 0)
    }

}

public struct Rect {

    let origin: Point
    let size: Size

    var maxX: Float {
        return origin.x + size.width
    }

    var maxY: Float {
        return origin.y + size.height
    }

}
