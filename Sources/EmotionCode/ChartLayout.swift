import UIKit
import Elm

class ChartLayout: UICollectionViewLayout {

    typealias Module = ChartLayoutModule

    let program = Module.makeProgram()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        program.setDelegate(self)
    }

    func setMode(_ mode: Module.Mode) {
        program.dispatch(.setMode(mode))
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let sections = 0..<collectionView.numberOfSections
        let itemsPerSection = sections.map(collectionView.numberOfItems)
        program.dispatch(
            .setItemsPerSection(itemsPerSection),
            .setViewSize(collectionView.visibleContentSize.floatSize)
        )
    }

    override var collectionViewContentSize: CGSize {
        return program.view.chartSize.cgSize
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { preconditionFailure() }
        guard let verticalContentOffset = program.view.proposedVerticalContentOffset else { return proposedContentOffset }
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
        let frame = program.view.itemFrames[indexPath.section][indexPath.item]
        return UICollectionViewLayoutAttributes(indexPath: indexPath, frame: frame.cgRect)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ChartHeaderView.columnKind:
            let column = (indexPath.section + ChartLayoutModule.View.numberOfColumns) % ChartLayoutModule.View.numberOfColumns
            let frame = program.view.columnHeaderFrames[column]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        case ChartHeaderView.rowKind:
            let row = indexPath.section / ChartLayoutModule.View.numberOfColumns
            let frame = program.view.rowHeaderFrames[row]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        default: return nil
        }
    }

}

extension ChartLayout: ElmDelegate {

    func program(_ program: Program<ChartLayoutModule>, didUpdate view: ChartLayoutModule.View) {}
    func program(_ program: Program<ChartLayoutModule>, didEmit command: ()) {}

}

private extension CGSize {
    var floatSize: Size {
        return Size(width: Float(width), height: Float(height))
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
