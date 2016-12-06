import Foundation

public protocol HeaderFrameCalculator {

    func frameForColumnHeader(at indexPath: IndexPath) -> Rect?
    func frameForRowHeader(at indexPath: IndexPath) -> Rect?

}

public extension HeaderFrameCalculator where Self: DefaultHeaderFrameCalculator {

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

public typealias DefaultHeaderFrameCalculator = HeaderFrameCalculator
    & HeaderPositionCalculator
    & HeaderSizeCalculator
    & NumberOfColumnsProvider
