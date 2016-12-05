import Foundation

public protocol ItemPositionCalculator {

    var mode: ChartLayoutMode { get }

    var contentPadding: Float { get }

    var itemWidth: Float { get }
    func itemHeight(forSection section: Int) -> Float
    var itemSpacing: Float { get }
    var rowHeaderSize: Size { get }
    static var horizontalSectionSpacing: Float { get }

    func yPosition(forSection section: Int) -> Float

    static var numberOfColumns: Int { get }

}

public extension ItemPositionCalculator {

    func positionForItem(at indexPath: IndexPath) -> Point {
        let xPosition = xPositionForItem(at: indexPath)
        let yPosition = yPositionForItem(at: indexPath)
        return Point(x: xPosition, y: yPosition)
    }

    func xPositionForItem(at indexPath: IndexPath) -> Float {
        let column = (indexPath.section + Self.numberOfColumns) % Self.numberOfColumns
        let xPosition = contentPadding + rowHeaderSize.width
        switch mode {
        case .all: return xPosition + Self.horizontalSectionSpacing + Float(column) * (itemWidth + Self.horizontalSectionSpacing)
        case .group, .emotion: return xPosition + Float(column) * (itemWidth + contentPadding)
        }
    }

    func yPositionForItem(at indexPath: IndexPath) -> Float {
        let cumulativeSpacingHeight = Float(indexPath.item) * itemSpacing
        let height = itemHeight(forSection: indexPath.section)
        let cumulativeContentHeight = Float(indexPath.item) * height
        return yPosition(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
    }

}
