import UIKit
import ChartLayoutCalculator

class ChartLayout: UICollectionViewLayout, ChartLayoutCalculator {

    var numberOfSections: Int {
        return collectionView?.numberOfSections ?? 0
    }

    func numberOfItems(inSection section: Int) -> Int {
        return collectionView?.numberOfItems(inSection: section) ?? 0
    }

    var viewWidth: Float {
        return Float(collectionView?.bounds.width ?? 0)
    }

    var visibleContentHeight: Float {
        return Float(collectionView?.visibleContentHeight ?? 0)
    }

    var mode: ChartLayoutMode = .all

    override var collectionViewContentSize: CGSize { return chartSize.cgSize }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { preconditionFailure() }
        guard let verticalContentOffset = verticalContentOffset else { return proposedContentOffset }
        let x = proposedContentOffset.x
        let y = CGFloat(verticalContentOffset) - collectionView.contentInset.top
        return CGPoint(x: x, y: y)
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
        let frame = frameForItem(at: indexPath)
        return UICollectionViewLayoutAttributes(indexPath: indexPath, frame: frame.cgRect)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ChartHeaderView.columnKind:
            guard let frame = frameForColumnHeader(at: indexPath) else { return nil }
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        case ChartHeaderView.rowKind:
            guard let frame = frameForRowHeader(at: indexPath) else { return nil }
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
}

private extension Point {
    var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
