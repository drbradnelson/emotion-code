import Foundation

public protocol HeaderFrameCalculator {

    func positionForColumnHeader(at indexPath: IndexPath) -> Point
    func positionForRowHeader(at indexPath: IndexPath) -> Point

    var columnHeaderSize: Size { get }
    var rowHeaderSize: Size { get }

    static var numberOfColumns: Int { get }

}

public extension HeaderFrameCalculator {

    func frameForColumnHeader(at indexPath: IndexPath) -> Rect? {
        guard indexPath.section <= Self.numberOfColumns, indexPath.item == 0 else { return nil }
        let frameOffset = positionForColumnHeader(at: indexPath)
        return Rect(origin: frameOffset, size: columnHeaderSize)
    }

    func frameForRowHeader(at indexPath: IndexPath) -> Rect? {
        guard (indexPath.section + Self.numberOfColumns) % Self.numberOfColumns == 0 else { return nil }
        let frameOffset = positionForRowHeader(at: indexPath)
        return Rect(origin: frameOffset, size: rowHeaderSize)
    }

}
