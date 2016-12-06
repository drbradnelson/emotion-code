import Foundation

public protocol ItemFrames {

    func frameForItem(at indexPath: IndexPath) -> Rect

}

public extension ItemFrames where Self: DefaultItemFrames {

    func frameForItem(at indexPath: IndexPath) -> Rect {
        let frameOffset = positionForItem(at: indexPath)
        let height = itemHeight(forSection: indexPath.section)
        let size = Size(width: itemWidth, height: height)
        return Rect(origin: frameOffset, size: size)
    }

}

public typealias DefaultItemFrames = ItemFrames
    & ItemSizes
    & ItemPositions
