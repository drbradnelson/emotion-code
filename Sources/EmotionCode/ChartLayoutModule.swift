import Foundation
import Elm

// swiftlint:disable mark
// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity

struct ChartLayoutModule: Module {

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
    }

    typealias Command = Void

    struct View {
        let chartSize: Size
        let proposedVerticalContentOffset: Float?
        let itemFrames: [[Rect]]
        let columnHeaderFrames: [[Rect]]
        let rowHeaderFrames: [[Rect]]
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

        let sectionsRange = 0..<model.itemsPerSection.count

        //
        // MARK: -
        // MARK: General
        //

        var contentPadding: Float {
            switch model.mode {
            case .all: return 10
            case .section, .emotion: return 20
            }
        }

        //
        // MARK: -
        // MARK: Section spacing
        //

        var sectionSpacing: Size {
            let width: Float = 15
            let height: Float
            switch model.mode {
            case .all: height = 15
            case .section, .emotion: height = 20
            }
            return Size(width: width, height: height)
        }

        //
        // MARK: -
        // MARK: Item spacing
        //

        var itemSpacing: Float {
            switch model.mode {
            case .all: return 5
            case .section: return 10
            case .emotion: return sectionSpacing.height
            }
        }

        //
        // MARK: -
        // MARK: Item heights
        //

        let itemHeights = sectionsRange.map { section -> Float in
            switch model.mode {
            case .all: return 30
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

        let rowHeaderSize = Size(width: 30, height: maximumSectionHeight)

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

        let columnHeaderSize = Size(width: itemWidth, height: 30)

        //
        // MARK: -
        // MARK: Section position
        //

        let sectionYPositions = sectionsRange.map { section -> Float in
            let row = section / View.numberOfColumns
            let cumulativeContentHeight = maximumSectionHeight * Float(row)
            let cumulativeSpacingHeight = sectionSpacing.height * Float(row)
            return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + contentPadding
        }

        //
        // MARK: -
        // MARK: Item position
        //

        let xPositionsForItemsInSection = sectionsRange.map { section -> Float in
            let column = (section + View.numberOfColumns) % View.numberOfColumns
            let xPosition = contentPadding + rowHeaderSize.width
            switch model.mode {
            case .all: return xPosition + sectionSpacing.width + Float(column) * (itemWidth + sectionSpacing.width)
            case .section, .emotion: return xPosition + Float(column) * (itemWidth + contentPadding)
            }
        }

        let yPositionsForItems = sectionsRange.map { section -> [Float] in
            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let cumulativeSpacingHeight = Float(item) * itemSpacing
                let cumulativeContentHeight = Float(item) * itemHeights[section]
                return sectionYPositions[section] + cumulativeContentHeight + cumulativeSpacingHeight
            }
        }

        let itemPositions = sectionsRange.map { section -> [Point] in
            let xPosition = xPositionsForItemsInSection[section]

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
            guard !sectionsRange.isEmpty else { return nil }
            switch model.mode {
            case .all:
                return nil
            case .section(let section):
                return sectionYPositions[section] - sectionSpacing.height
            case .emotion(let indexPath):
                return yPositionsForItems[indexPath.section][indexPath.item] - sectionSpacing.height
            }
        }

        //
        // MARK: -
        // MARK: Header position
        //

        let positionsForColumnHeaders = sectionsRange.map { section -> [Point] in
            let x = xPositionsForItemsInSection[section]

            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let y: Float
                switch model.mode {
                case .all: y = contentPadding
                case .section, .emotion: y = contentPadding - columnHeaderSize.height
                }
                return Point(x: x, y: y)
            }
        }

        let positionsForRowHeaders = sectionsRange.map { section -> [Point] in
            let y = sectionYPositions[section]

            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let x: Float
                switch model.mode {
                case .all: x = contentPadding
                case .section, .emotion: x = contentPadding - rowHeaderSize.width
                }
                return Point(x: x, y: y)
            }
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        let columnHeaderFrames = sectionsRange.map { section -> [Rect] in
            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let position = positionsForColumnHeaders[section][item]
                return Rect(origin: position, size: columnHeaderSize)
            }
        }

        let rowHeaderFrames = sectionsRange.map { section -> [Rect] in
            let itemsRange = 0..<model.itemsPerSection[section]
            return itemsRange.map { item in
                let position = positionsForRowHeaders[section][item]
                return Rect(origin: position, size: rowHeaderSize)
            }
        }

        //
        // MARK: -
        // MARK: Chart size
        //

        var chartSize: Size {
            guard let positionForLastSection = sectionYPositions.last else { return .zero }
            let contentHeight = positionForLastSection + maximumSectionHeight
            let height = contentHeight + sectionSpacing.height + contentPadding
            let width: Float
            switch model.mode {
            case .all:
                width = model.viewSize.width
            case .section, .emotion:
                width = model.viewSize.width * Float(View.numberOfColumns) - contentPadding + rowHeaderSize.width
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
