import Foundation

public protocol HeaderPositions {

    func positionForColumnHeader(at indexPath: IndexPath) -> Point
    func positionForRowHeader(at indexPath: IndexPath) -> Point

}

public extension HeaderPositions where Self: DefaultHeaderPositions {

    func positionForColumnHeader(at indexPath: IndexPath) -> Point {
        let x = xPositionForItem(at: indexPath)
        let y: Float
        switch mode {
        case .all: y = contentPadding
        case .section, .emotion: y = contentPadding - columnHeaderSizes.height
        }
        return Point(x: x, y: y)
    }

    func positionForRowHeader(at indexPath: IndexPath) -> Point {
        let x: Float
        switch mode {
        case .all: x = contentPadding
        case .section, .emotion: x = contentPadding - rowHeaderSizes.width
        }
        let y = yPosition(forSection: indexPath.section)
        return Point(x: x, y: y)
    }

}

public typealias DefaultHeaderPositions = HeaderPositions
    & ContentPadding
    & ChartMode
    & HeaderSizes
    & SectionPositions
    & ItemPositions
