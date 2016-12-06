import Foundation

public protocol ItemFrameCalculator {

    func frameForItem(at indexPath: IndexPath) -> Rect

}

public extension ItemFrameCalculator where Self: DefaultItemFrameCalculator {

    func frameForItem(at indexPath: IndexPath) -> Rect {
        let frameOffset = positionForItem(at: indexPath)
        let height = itemHeight(forSection: indexPath.section)
        let size = Size(width: itemWidth, height: height)
        return Rect(origin: frameOffset, size: size)
    }

}

public typealias DefaultItemFrameCalculator = ItemFrameCalculator
    & ItemSizeCalculator
    & ItemPositionCalculator
