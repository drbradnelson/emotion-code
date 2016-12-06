import Foundation

public protocol HeaderPositionCalculator {

    func positionForColumnHeader(at indexPath: IndexPath) -> Point
    func positionForRowHeader(at indexPath: IndexPath) -> Point

}

public extension HeaderPositionCalculator where Self: DefaultHeaderPositionCalculator {

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

public typealias DefaultHeaderPositionCalculator = HeaderPositionCalculator
    & ContentPaddingProvider
    & ChartModeProvider
    & HeaderSizeCalculator
    & SectionPositionCalculator
    & ItemPositionCalculator
