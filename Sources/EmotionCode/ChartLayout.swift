import UIKit
import Elm

final class ChartLayout: UICollectionViewLayout {

    static let numberOfColumns = 2

    typealias Module = ChartLayoutModule

    var program: Program<Module>!
    var mode: Module.Mode!

    override func prepare() {
        super.prepare()
        let sections = 0..<collectionView!.numberOfSections
        let itemsPerSection = sections.map(collectionView!.numberOfItems)
        program = Module.makeProgram(delegate: self, flags: .init(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: ChartLayout.numberOfColumns,
            topContentInset: .init(collectionView!.contentInset.top),
            bottomContentInset: .init(collectionView!.contentInset.bottom),
            viewSize: .init(cgSize: collectionView!.visibleContentSize)
        ))
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
        let item = program.view.items[indexPath]!
        return UICollectionViewLayoutAttributes(indexPath: indexPath, item: item)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let header: ChartLayoutModule.Header?
        switch elementKind {
        case ChartHeaderView.columnKind:
            header = program.view.columnHeaders[indexPath]
        case ChartHeaderView.rowKind:
            header = program.view.rowHeaders[indexPath]
        default:
            header = nil
        }
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, header: header)
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

private extension Size {
    var cgSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

extension Size {
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
