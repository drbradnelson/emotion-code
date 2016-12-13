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

        let numberOfSections = model.itemsPerSection.count

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
        // MARK: Section height
        //

        var maximumSectionHeight: Float {
            let sections = 0..<numberOfSections
            let sectionHeights = sections.map(heightForSection)
            return sectionHeights.max() ?? 0
        }

        func heightForSection(section: Int) -> Float {
            let itemCount = model.itemsPerSection[section]
            let verticalItemSpacing = Float(itemCount - 1) * itemSpacing
            let totalItemHeights = Float(itemCount) * itemHeight(forSection: section)
            return totalItemHeights + verticalItemSpacing
        }

        //
        // MARK: -
        // MARK: Horizontal something
        //

        let rowHeaderSize = Size(width: 30, height: maximumSectionHeight)

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
        // MARK: Vertical something
        //

        let columnHeaderSize = Size(width: itemWidth, height: 30)

        func itemHeight(forSection section: Int) -> Float {
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
        // MARK: Item position
        //

        func positionForItem(at indexPath: IndexPath) -> Point {
            let xPosition = xPositionForItem(at: indexPath)
            let yPosition = yPositionForItem(at: indexPath)
            return Point(x: xPosition, y: yPosition)
        }

        func xPositionForItem(at indexPath: IndexPath) -> Float {
            let column = (indexPath.section + View.numberOfColumns) % View.numberOfColumns
            let xPosition = contentPadding + rowHeaderSize.width
            switch model.mode {
            case .all: return xPosition + sectionSpacing.width + Float(column) * (itemWidth + sectionSpacing.width)
            case .section, .emotion: return xPosition + Float(column) * (itemWidth + contentPadding)
            }
        }

        func yPositionForItem(at indexPath: IndexPath) -> Float {
            let cumulativeSpacingHeight = Float(indexPath.item) * itemSpacing
            let height = itemHeight(forSection: indexPath.section)
            let cumulativeContentHeight = Float(indexPath.item) * height
            return yPosition(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
        }

        //
        // MARK: -
        // MARK: Item frame
        //

        func frameForItem(at indexPath: IndexPath) -> Rect {
            let frameOffset = positionForItem(at: indexPath)
            let height = itemHeight(forSection: indexPath.section)
            let size = Size(width: itemWidth, height: height)
            return Rect(origin: frameOffset, size: size)
        }

        //
        // MARK: -
        // MARK: Section position
        //

        func yPosition(forSection section: Int) -> Float {
            let row = section / View.numberOfColumns
            let cumulativeContentHeight = maximumSectionHeight * Float(row)
            let cumulativeSpacingHeight = sectionSpacing.height * Float(row)
            return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + sectionSpacing.height + contentPadding
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
                return yPosition(forSection: section) - sectionSpacing.height
            case .emotion(let indexPath):
                return yPositionForItem(at: indexPath) - sectionSpacing.height
            }
        }

        //
        // MARK: -
        // MARK: Header position
        //

        func positionForColumnHeader(at indexPath: IndexPath) -> Point {
            let x = xPositionForItem(at: indexPath)
            let y: Float
            switch model.mode {
            case .all: y = contentPadding
            case .section, .emotion: y = contentPadding - columnHeaderSize.height
            }
            return Point(x: x, y: y)
        }

        func positionForRowHeader(at indexPath: IndexPath) -> Point {
            let x: Float
            switch model.mode {
            case .all: x = contentPadding
            case .section, .emotion: x = contentPadding - rowHeaderSize.width
            }
            let y = yPosition(forSection: indexPath.section)
            return Point(x: x, y: y)
        }

        //
        // MARK: -
        // MARK: Header frame
        //

        func frameForColumnHeader(at indexPath: IndexPath) -> Rect {
            let frameOffset = positionForColumnHeader(at: indexPath)
            return Rect(origin: frameOffset, size: columnHeaderSize)
        }

        func frameForRowHeader(at indexPath: IndexPath) -> Rect {
            let frameOffset = positionForRowHeader(at: indexPath)
            return Rect(origin: frameOffset, size: rowHeaderSize)
        }

        //
        // MARK: -
        // MARK: Chart size
        //

        var chartSize: Size {
            let lastSection = numberOfSections - 1
            let collectionViewContentHeight = yPosition(forSection: lastSection) + maximumSectionHeight
            let height = collectionViewContentHeight + sectionSpacing.height + contentPadding
            let width: Float
            switch model.mode {
            case .all:
                width = model.viewSize.width
            case .section, .emotion:
                width = model.viewSize.width * Float(View.numberOfColumns) - contentPadding + rowHeaderSize.width
            }
            return Size(width: width, height: height)
        }

        let indexPaths = IndexPath.with(itemsPerSection: model.itemsPerSection)
        let itemFrames = indexPaths.map { $0.map(frameForItem) }
        let columnHeaderFrames = indexPaths.map { $0.map(frameForColumnHeader) }
        let rowHeaderFrames = indexPaths.map { $0.map(frameForRowHeader) }

        return View(
            chartSize: chartSize,
            proposedVerticalContentOffset: proposedVerticalContentOffset,
            itemFrames: itemFrames,
            columnHeaderFrames: columnHeaderFrames,
            rowHeaderFrames: rowHeaderFrames
        )

    }

}

private extension IndexPath {

    static func with(itemsPerSection: [Int]) -> [[IndexPath]] {
        let sections = 0..<itemsPerSection.count
        let itemRanges = itemsPerSection.map { itemCount in 0..<itemCount }
        return zip(itemRanges, sections).flatMap(IndexPath.indexPaths)
    }

    static func indexPaths(in range: CountableRange<Int>, section: Int) -> [IndexPath] {
        return range.map { item in
            IndexPath(item: item, section: section)
        }
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
