import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity

struct ChartLayoutModule: ElmModule {

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

        //
        // MARK: Spacing & padding
        //

        var contentPadding: Float {
            switch mode {
            case .all: return 10
            case .section, .emotion: return 20
            }
        }

        var sectionSpacing: Size {
            let width: Float = 15
            let height: Float
            switch mode {
            case .all: height = 15
            case .section, .emotion: height = 20
            }
            return Size(width: width, height: height)
        }

        var itemSpacing: Float {
            switch mode {
            case .all: return 5
            case .section: return 10
            case .emotion: return sectionSpacing.height
            }
        }

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

    static func update(for message: Message, model: inout Model) -> [Command] {
        switch message {
        case .setMode(let mode):
            model.mode = mode
        case .setItemsPerSection(let itemsPerSection):
            model.itemsPerSection = itemsPerSection
        case .setViewSize(let size):
            model.viewSize = size
        }
        return []
    }

    static func view(for model: Model) -> View {

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

        let rowsCount = sectionsCount / View.numberOfColumns
        let rowsRange = 0..<rowsCount

        //
        // MARK: -
        // MARK: Item heights
        //

        let itemHeights = sectionsRange.map { section -> Float in
            switch model.mode {
            case .all: return 30
            case .section:
                let itemCount = model.itemsPerSection[section]
                let totalPaddingHeight = model.contentPadding * 2
                let totalSpacingHeight = model.itemSpacing * Float(itemCount - 1)
                let totalAvailableContentHeight = model.viewSize.height - totalPaddingHeight - totalSpacingHeight
                return totalAvailableContentHeight / Float(itemCount)
            case .emotion:
                let totalPaddingHeight = model.contentPadding * 2
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
            let verticalItemSpacing = Float(itemCount - 1) * model.itemSpacing
            let totalItemHeights = Float(itemCount) * itemHeights[section]
            return totalItemHeights + verticalItemSpacing
        }

        let maximumSectionHeight = sectionHeights.max() ?? 0

        //
        // MARK: -
        // MARK: Row header size
        //

        let rowHeaderSize = Size(width: 30, height: maximumSectionHeight)

        //
        // MARK: -
        // MARK: Item width
        //

        var itemWidth: Float {
            switch model.mode {
            case .all:
                let totalAvailableWidth = model.viewSize.width - model.contentPadding * 2 - rowHeaderSize.width - model.sectionSpacing.width
                let totalSpacingWidth = model.sectionSpacing.width * Float(View.numberOfColumns - 1)
                let totalContentWidth = totalAvailableWidth - totalSpacingWidth
                return totalContentWidth / Float(View.numberOfColumns)
            case .section, .emotion:
                return model.viewSize.width - model.contentPadding * 2
            }
        }

        //
        // MARK: -
        // MARK: Column header size
        //

        let columnHeaderSize = Size(width: itemWidth, height: 30)

        //
        // MARK: -
        // MARK: Column and row positions
        //

        let rowYPositions = rowsRange.map { row -> Float in
            let cumulativeContentHeight = maximumSectionHeight * Float(row)
            let cumulativeSpacingHeight = model.sectionSpacing.height * Float(row)
            return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + model.sectionSpacing.height + model.contentPadding
        }

        let columnXPositions = columnsRange.map { column -> Float in
            let xPosition = model.contentPadding + rowHeaderSize.width

            switch model.mode {
            case .all: return xPosition + model.sectionSpacing.width + Float(column) * (itemWidth + model.sectionSpacing.width)
            case .section, .emotion: return xPosition + Float(column) * (itemWidth + model.contentPadding)
            }
        }

        //
        // MARK: -
        // MARK: Item position
        //

        let yPositionsForItems = sectionsRange.map { section -> [Float] in
            let itemsRange = 0..<model.itemsPerSection[section]
            let row = rowIndex(forSection: section)
            return itemsRange.map { item in
                let cumulativeSpacingHeight = Float(item) * model.itemSpacing
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
                return rowYPositions[row] - model.sectionSpacing.height
            case .emotion(let indexPath):
                return yPositionsForItems[indexPath.section][indexPath.item] - model.sectionSpacing.height
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
            case .all: y = model.contentPadding
            case .section, .emotion: y = model.contentPadding - columnHeaderSize.height
            }

            return Point(x: x, y: y)
        }

        let positionsForRowHeaders = rowsRange.map { row -> Point in
            let y = rowYPositions[row]

            let x: Float
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

        var chartSize: Size {
            guard let positionForLastRow = rowYPositions.last else { return .zero }

            let contentHeight = positionForLastRow + maximumSectionHeight
            let height = contentHeight + model.contentPadding

            let width: Float
            switch model.mode {
            case .all:
                width = model.viewSize.width
            case .section, .emotion:
                width = model.viewSize.width * Float(View.numberOfColumns) - model.contentPadding + rowHeaderSize.width
            }

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
}
