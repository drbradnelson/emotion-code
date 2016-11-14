import UIKit

final class ChartLayout: UICollectionViewLayout {

    // MARK: Parametrization

    static let numberOfColumns = 2

    private let contentPadding: CGFloat = 10
    private let itemSpacing: CGFloat = 5
    private let itemHeight: CGFloat = 30
    private let horizontalSectionSpacing: CGFloat = 15
    private let verticalSectionSpacing: CGFloat = 15

    // MARK: Content size

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let lastSection = collectionView.numberOfSections - 1
        let collectionViewContentHeight = yOffset(forSection: lastSection) + maximumSectionHeight
        return CGSize(width: collectionView.bounds.width, height: collectionViewContentHeight + contentPadding)
    }

    // MARK: Layout attributes

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let items = collectionView.indexPaths.flatMap(layoutAttributesForItem)
        let columnHeaders = collectionView.indexPaths.flatMap(layoutAttributesForColumnHeader)
        let rowHeaders = collectionView.indexPaths.flatMap(layoutAttributesForRowHeader)
        return (items + columnHeaders + rowHeaders).filter { layoutAttributes in layoutAttributes.frame.intersects(rect) }
    }

    // MARK: Layout attributes for item

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let frameOffset = frameOffsetForLayoutAttributes(at: indexPath)
        let frame = CGRect(origin: frameOffset, size: itemSize)
        return UICollectionViewLayoutAttributes(indexPath: indexPath, frame: frame)
    }

    private func frameOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGPoint {
        let xOffset = xOffsetForLayoutAttributes(at: indexPath)
        let yOffset = yOffsetForLayoutAttributes(at: indexPath)
        return CGPoint(x: xOffset, y: yOffset)
    }

    private func xOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
        let column = (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
        return contentPadding + CGFloat(column) * (itemSize.width + horizontalSectionSpacing) + rowHeaderSize.width
    }

    private func yOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
        let cumulativeContentHeight = CGFloat(indexPath.item) * itemSize.height
        let cumulativeSpacingHeight = CGFloat(indexPath.item) * itemSpacing
        return yOffset(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
    }

    private func yOffset(forSection section: Int) -> CGFloat {
        let row = section / ChartLayout.numberOfColumns
        let cumulativeContentHeight = maximumSectionHeight * CGFloat(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * CGFloat(row)
        return contentPadding + columnHeaderSize.height + cumulativeContentHeight + cumulativeSpacingHeight
    }

    // MARK: Layout attributes for headers

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case ChartHeaderView.kindColumnHeader:
            return layoutAttributesForColumnHeader(at: indexPath)
        case ChartHeaderView.kindRowHeader:
            return layoutAttributesForRowHeader(at: indexPath)
        default: return nil
        }
    }

    private func layoutAttributesForColumnHeader(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section <= ChartLayout.numberOfColumns, indexPath.row == 0 else { return nil }
        let frameOffset = frameOffsetForColumnHeader(at: indexPath)
        let frame = CGRect(origin: frameOffset, size: columnHeaderSize)
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ChartHeaderView.kindColumnHeader, with: indexPath, frame: frame)
    }

    private func layoutAttributesForRowHeader(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns == 0 else { return nil }
        let frameOffset = frameOffsetForRowHeader(at: indexPath)
        let frame = CGRect(origin: frameOffset, size: rowHeaderSize)
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ChartHeaderView.kindRowHeader, with: indexPath, frame: frame)
    }

    private func frameOffsetForColumnHeader(at indexPath: IndexPath) -> CGPoint {
        let xOffset = xOffsetForLayoutAttributes(at: indexPath)
        return CGPoint(x: xOffset, y: contentPadding)
    }

    private func frameOffsetForRowHeader(at indexPath: IndexPath) -> CGPoint {
        let y = yOffset(forSection: indexPath.section)
        return CGPoint(x: contentPadding, y: y)
    }

    // MARK: Headers size

    private var columnHeaderSize: CGSize {
        return CGSize(width: itemSize.width, height: itemHeight * 1.5)
    }

    private var rowHeaderSize: CGSize {
        return CGSize(width: itemHeight * 1.5, height: maximumSectionHeight)
    }

    // MARK: Item size

    private var itemSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let totalAvailableWidth = collectionView.bounds.width - contentPadding * 2 - rowHeaderSize.width
        let totalSpacingWidth = horizontalSectionSpacing * CGFloat(ChartLayout.numberOfColumns - 1)
        let totalContentWidth = totalAvailableWidth - totalSpacingWidth
        let itemWidth = totalContentWidth / CGFloat(ChartLayout.numberOfColumns)
        return CGSize(width: itemWidth, height: itemHeight)
    }

    // MARK: Section height

    private var maximumSectionHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let sections = 0..<collectionView.numberOfSections
        let sectionHeights = sections.map(heightForSection)
        return sectionHeights.max() ?? 0
    }

    private func heightForSection(section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let totalItemHeights = CGFloat(numberOfItems) * itemHeight
        let verticalItemSpacing = CGFloat(numberOfItems - 1) * itemSpacing
        return totalItemHeights + verticalItemSpacing
    }

}

extension UICollectionViewLayoutAttributes {

    convenience init(indexPath: IndexPath, frame: CGRect) {
        self.init(forCellWith: indexPath)
        self.frame = frame
    }

    convenience init(forSupplementaryViewOfKind elementKind: String, with indexPath: IndexPath, frame: CGRect) {
        self.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        self.frame = frame
    }

}
