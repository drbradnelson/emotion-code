import UIKit
import Elm

final class ChartLayout: UICollectionViewLayout {

    static let numberOfColumns = 2

    var store: Store<ChartLayoutProgram>!
    var mode: ChartLayoutProgram.Mode!

    override func prepare() {
        super.prepare()
        guard store == nil else { return }
        let sections = 0..<collectionView!.numberOfSections
        let itemsPerSection = sections.map(collectionView!.numberOfItems)
        store = ChartLayoutProgram.makeStore(
            delegate: self,
            seed: .init(
                mode: mode,
                itemsPerSection: itemsPerSection,
                numberOfColumns: ChartLayout.numberOfColumns,
                topContentInset: .init(collectionView!.contentInset.top),
                bottomContentInset: .init(collectionView!.contentInset.bottom),
                viewSize: .init(cgSize: collectionView!.bounds.size)
            )
        )
    }

    override var collectionViewContentSize: CGSize {
        return store.view.chartSize.cgSize
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
        let item = store.view.items[indexPath]!
        return UICollectionViewLayoutAttributes(indexPath: indexPath, item: item)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let header: ChartLayoutProgram.Header?
        switch elementKind {
        case ChartHeaderView.columnKind:
            header = store.view.columnHeaders[indexPath]
        case ChartHeaderView.rowKind:
            header = store.view.rowHeaders[indexPath]
        default:
            header = nil
        }
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, header: header)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView!.bounds.size != newBounds.size
    }

}

extension ChartLayout: StoreDelegate {

    func store(_ store: Store<ChartLayoutProgram>, didUpdate view: ChartLayoutProgram.View) {}
    func store(_ store: Store<ChartLayoutProgram>, didRequest action: ChartLayoutProgram.Action) {}

}

private extension UICollectionViewLayoutAttributes {

    convenience init(indexPath: IndexPath, item: ChartLayoutProgram.Item) {
        self.init(forCellWith: indexPath)
        self.frame = item.frame.cgRect
        self.alpha = .init(item.alpha)
    }

    convenience init?(forSupplementaryViewOfKind elementKind: String, with indexPath: IndexPath, header: ChartLayoutProgram.Header?) {
        guard let header = header else { return nil }
        self.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        self.frame = header.frame.cgRect
        self.alpha = .init(header.alpha)
    }

}

private extension Rect {
    var cgRect: CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

extension Size {

    var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }

    init(cgSize: CGSize) {
        width = .init(cgSize.width)
        height = .init(cgSize.height)
    }

}

private extension Point {

    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }

}
