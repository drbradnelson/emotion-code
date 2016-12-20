import Foundation

public protocol ItemFrameCalculator {

    var itemWidth: Float { get }

    func positionForItem(at indexPath: IndexPath) -> Point
    func itemHeight(forSection section: Int) -> Float

}

public extension ItemFrameCalculator {

    func frameForItem(at indexPath: IndexPath) -> Rect {
        let frameOffset = positionForItem(at: indexPath)
        let height = itemHeight(forSection: indexPath.section)
        let size = Size(width: itemWidth, height: height)
        return Rect(origin: frameOffset, size: size)
    }

}
