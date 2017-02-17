import UIKit
import Elm

// swiftlint:disable cyclomatic_complexity

final class ChartLayout: UICollectionViewLayout {

    static let numberOfColumns = 2

    var program: Program<ChartLayoutModule>!

    override var collectionViewContentSize: CGSize {
        return program.view.chartSize.cgSize
    }

    override func prepare() {
        super.prepare()
        program.dispatch(.systemDidSetViewSize(.init(collectionView!.visibleContentSize)))
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
        let item = program.view.items[indexPath.section][indexPath.item]
        return UICollectionViewLayoutAttributes(indexPath: indexPath, item: item)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let isFirstItem = indexPath.item == 0
        guard isFirstItem else { return nil }
        switch elementKind {
        case ChartHeaderView.columnKind:
            let isFirstRow = (indexPath.section < ChartLayout.numberOfColumns)
            guard isFirstRow else { return nil }
            let header = program.view.columnHeaders[indexPath.section]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, header: header)
        case ChartHeaderView.rowKind:
            let isFirstColumn = (indexPath.section % ChartLayout.numberOfColumns == 0)
            guard isFirstColumn else { return nil }
            let row = indexPath.section / ChartLayout.numberOfColumns
            let header = program.view.rowHeaders[row]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, header: header)
        default: return nil
        }
    }

}

extension ChartLayout: Elm.Delegate {

    public func program(_ program: Program<ChartLayoutModule>, didUpdate view: ChartLayoutModule.View) {}
    public func program(_ program: Program<ChartLayoutModule>, didEmit command: ChartLayoutModule.Command) {}

}

private extension UICollectionViewLayoutAttributes {

    convenience init(indexPath: IndexPath, item: ChartLayoutModule.Item) {
        self.init(forCellWith: indexPath)
        self.frame = item.frame.cgRect
        self.alpha = .init(item.alpha)
    }

    convenience init?(forSupplementaryViewOfKind elementKind: String, with indexPath: IndexPath, header: ChartLayoutModule.Header?) {
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
