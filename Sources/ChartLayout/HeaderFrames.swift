import Foundation

public protocol HeaderFrames {

    func frameForColumnHeader(at indexPath: IndexPath) -> Rect?
    func frameForRowHeader(at indexPath: IndexPath) -> Rect?

}

public extension HeaderFrames where Self: DefaultHeaderFrames {

    func frameForColumnHeader(at indexPath: IndexPath) -> Rect? {
        guard indexPath.section <= Self.numberOfColumns, indexPath.item == 0 else { return nil }
        let frameOffset = positionForColumnHeader(at: indexPath)
        return Rect(origin: frameOffset, size: columnHeaderSizes)
    }

    func frameForRowHeader(at indexPath: IndexPath) -> Rect? {
        guard (indexPath.section + Self.numberOfColumns) % Self.numberOfColumns == 0 else { return nil }
        let frameOffset = positionForRowHeader(at: indexPath)
        return Rect(origin: frameOffset, size: rowHeaderSizes)
    }

}

public typealias DefaultHeaderFrames = HeaderFrames
    & HeaderPositions
    & HeaderSizes
    & NumberOfColumns
