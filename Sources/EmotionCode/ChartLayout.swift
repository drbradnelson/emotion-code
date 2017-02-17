import UIKit
import Elm

final class ChartLayout: UICollectionViewLayout {

    typealias Module = ChartLayoutModule

    static let numberOfColumns = 2

    private var program: Program<ChartLayoutModule>!

    func setProgramModel(mode: Module.Mode, itemsPerSection: [Int], viewSize: CGSize, topContentInset: CGFloat) {
        program = ChartLayoutModule.makeProgram(delegate: self, flags: .init(
            mode: mode,
            itemsPerSection: itemsPerSection,
            numberOfColumns: ChartLayout.numberOfColumns,
            topContentInset: Int(topContentInset),
            viewSize: .init(cgSize: viewSize)
            )
        )
    }

    override var collectionViewContentSize: CGSize {
        return program.view.chartSize.cgSize
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let verticalContentOffset = program.view.proposedVerticalContentOffset else { return proposedContentOffset }
        let x = proposedContentOffset.x
        let y = CGFloat(verticalContentOffset)
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
            let frame = program.view.columnHeaderFrames[indexPath.section]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        case ChartHeaderView.rowKind:
            let frame = program.view.rowHeaderFrames[indexPath.section]
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath, frame: frame.cgRect)
        default: return nil
        }
    }

}

extension ChartLayout: Elm.Delegate {

    public func program(_ program: Program<ChartLayoutModule>, didUpdate view: ChartLayoutModule.View) {}
    public func program(_ program: Program<ChartLayoutModule>, didEmit command: ChartLayoutModule.Command) {}

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

    init(cgSize: CGSize) {
        width = Int(cgSize.width)
        height = Int(cgSize.height)
    }

}

private extension Point {
    var cgPoint: CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
