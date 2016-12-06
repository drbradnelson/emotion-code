import Foundation

public protocol ItemPositions {

    func positionForItem(at indexPath: IndexPath) -> Point

    func xPositionForItem(at indexPath: IndexPath) -> Float
    func yPositionForItem(at indexPath: IndexPath) -> Float

}

public extension ItemPositions where Self: DefaultItemPositions {

    func positionForItem(at indexPath: IndexPath) -> Point {
        let xPosition = xPositionForItem(at: indexPath)
        let yPosition = yPositionForItem(at: indexPath)
        return Point(x: xPosition, y: yPosition)
    }

    func xPositionForItem(at indexPath: IndexPath) -> Float {
        let column = (indexPath.section + Self.numberOfColumns) % Self.numberOfColumns
        let xPosition = contentPadding + rowHeaderSizes.width
        switch mode {
        case .all: return xPosition + horizontalSectionSpacing + Float(column) * (itemWidth + horizontalSectionSpacing)
        case .section, .emotion: return xPosition + Float(column) * (itemWidth + contentPadding)
        }
    }

    func yPositionForItem(at indexPath: IndexPath) -> Float {
        let cumulativeSpacingHeight = Float(indexPath.item) * itemSpacing
        let height = itemHeight(forSection: indexPath.section)
        let cumulativeContentHeight = Float(indexPath.item) * height
        return yPosition(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
    }

}

public typealias DefaultItemPositions = ItemPositions
    & ChartMode
    & ContentPadding
    & HeaderSizes
    & ItemSizes
    & ItemSpacing
    & NumberOfColumns
    & NumberOfSections
    & SectionPositions
    & SectionSpacing
