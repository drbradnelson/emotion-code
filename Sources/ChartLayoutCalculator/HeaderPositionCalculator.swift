import Foundation

public protocol HeaderPositionCalculator {

    var mode: ChartLayoutMode { get }

    var contentPadding: Float { get }
    var columnHeaderSize: Size { get }
    var rowHeaderSize: Size { get }

    func yPosition(forSection section: Int) -> Float
    func xPositionForItem(at indexPath: IndexPath) -> Float

}

public extension HeaderPositionCalculator {

    func positionForColumnHeader(at indexPath: IndexPath) -> Point {
        let x = xPositionForItem(at: indexPath)
        let y: Float
        switch mode {
        case .all: y = contentPadding
        case .section, .emotion: y = contentPadding - columnHeaderSize.height
        }
        return Point(x: x, y: y)
    }

    func positionForRowHeader(at indexPath: IndexPath) -> Point {
        let x: Float
        switch mode {
        case .all: x = contentPadding
        case .section, .emotion: x = contentPadding - rowHeaderSize.width
        }
        let y = yPosition(forSection: indexPath.section)
        return Point(x: x, y: y)
    }

}
