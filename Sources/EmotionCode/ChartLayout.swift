import UIKit
import Elm

final class ChartLayout: UICollectionViewLayout {

    static let numberOfColumns = 2

    var program: Program<ChartLayoutModule>!

    override func prepare() {
        super.prepare()
        program.dispatch(.systemDidSetViewSize(.init(collectionView!.visibleContentSize)))
    }

    override var collectionViewContentSize: CGSize {
        return program.view.chartSize.cgSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let items = collectionView.indexPaths.flatMap(layoutAttributesForItem)
        let columnHeaders = collectionView.indexPaths.flatMap { indexPath in
            layoutAttributesForSupplementaryView(ofKind: ChartHeaderView.columnKind, at: indexPath)
        }
        let rowHeaders = collectionView.indexPaths.flatMap { indexPath in
            layoutAttributesForSupplementaryView(ofKind: ChartHeaderView.rowKind, at: indexPath)
        }
        let elements = items + columnHeaders + rowHeaders
        return elements.filter { layoutAttributes in layoutAttributes.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let frame = program.view.itemFrames[indexPath.section][indexPath.item]
        return UICollectionViewLayoutAttributes(indexPath: indexPath, frame: frame.cgRect)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ChartHeaderView.columnKind:
            let frame = program.view.columnHeaderFrames[indexPath.section]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        case ChartHeaderView.rowKind:
            let frame = program.view.rowHeaderFrames[indexPath.section]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        default: return nil
        }
    }

}

private extension UICollectionViewLayoutAttributes {

    convenience init(indexPath: IndexPath, frame: CGRect) {
        self.init(forCellWith: indexPath)
        self.frame = frame
    }

    convenience init(forSupplementaryViewOfKind elementKind: String, with indexPath: IndexPath, frame: CGRect) {
        self.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        self.frame = frame
    }

}

private extension Rect {
    var cgRect: CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

private extension Size {

    var cgSize: CGSize {
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

    init(_ cgSize: CGSize) {
        width = Int(cgSize.width)
        height = Int(cgSize.height)
    }

}

extension Point {

    var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    init(_ cgPoint: CGPoint) {
        x = Int(cgPoint.x)
        y = Int(cgPoint.y)
    }

}
