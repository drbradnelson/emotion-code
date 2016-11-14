import UIKit

final class ChartColumnLayout: UICollectionViewLayout {

    // MARK: Parametrization

    private let contentPadding: CGFloat = 20
    private let itemSpacing: CGFloat = 10

    private func itemHeight(forSection section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let totalPaddingHeight = contentPadding * 2
        let totalSpacingHeight = itemSpacing * CGFloat(numberOfItems - 1)
        let totalAvailableContentHeight = collectionView.visibleContentHeight - totalPaddingHeight - totalSpacingHeight
        return totalAvailableContentHeight / CGFloat(numberOfItems)
    }

    private let verticalSectionSpacing: CGFloat = 20

    // MARK: Content frame

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let lastSection = collectionView.numberOfSections - 1
        let collectionViewContentHeight = yOffset(forSection: lastSection) + maximumSectionHeight
        return CGSize(width: collectionView.bounds.width * CGFloat(ChartLayout.numberOfColumns) - contentPadding + rowHeaderSize(forSection: 0).width, height: collectionViewContentHeight + verticalSectionSpacing)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
            let section = collectionView.indexPathForSelectedItem?.section else { return proposedContentOffset }
        let y = yOffset(forSection: section) - verticalSectionSpacing - collectionView.contentInset.top
        return CGPoint(x: proposedContentOffset.x, y: y)
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
        let size = itemSize(forSection: indexPath.section)
        let frame = CGRect(origin: frameOffset, size: size)
        return UICollectionViewLayoutAttributes(indexPath: indexPath, frame: frame)
    }

    private func frameOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGPoint {
        let xOffset = xOffsetForLayoutAttributes(at: indexPath)
        let yOffset = yOffsetForLayoutAttributes(at: indexPath)
        return CGPoint(x: xOffset, y: yOffset)
    }

    private func xOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
        let column = (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
        return contentPadding + rowHeaderSize(forSection: indexPath.section).width + CGFloat(column) * (itemWidth + contentPadding)
    }

    private func yOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
        let height = itemHeight(forSection: indexPath.section)
        let cumulativeContentHeight = CGFloat(indexPath.item) * height
        let cumulativeSpacingHeight = CGFloat(indexPath.item) * itemSpacing
        return yOffset(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
    }

    private func yOffset(forSection section: Int) -> CGFloat {
        let row = section / ChartLayout.numberOfColumns
        let cumulativeContentHeight = maximumSectionHeight * CGFloat(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * CGFloat(row)
        return verticalSectionSpacing + columnHeaderSize(forSection: section).height + cumulativeContentHeight + cumulativeSpacingHeight
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
        let size = columnHeaderSize(forSection: indexPath.section)
        let frame = CGRect(origin: frameOffset, size: size)
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ChartHeaderView.kindColumnHeader, with: indexPath, frame: frame)
    }

    private func layoutAttributesForRowHeader(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns == 0 else { return nil }
        let frameOffset = frameOffsetForRowHeader(at: indexPath)
        let size = rowHeaderSize(forSection: indexPath.section)
        let frame = CGRect(origin: frameOffset, size: size)
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

    private func columnHeaderSize(forSection section: Int) -> CGSize {
        let height = itemHeight(forSection: section)
        return CGSize(width: itemWidth, height: height * 1.5)
    }

    private func rowHeaderSize(forSection section: Int) -> CGSize {
        let height = itemHeight(forSection: section)
        return CGSize(width: height * 1.5, height: maximumSectionHeight)
    }

    // MARK: Item size

    private func itemSize(forSection section: Int) -> CGSize {
        let height = itemHeight(forSection: section)
        return CGSize(width: itemWidth, height: height)
    }

    private var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - contentPadding * 2
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
        let totalItemHeight = CGFloat(numberOfItems) * itemHeight(forSection: section)
        let totalVerticalItemSpacing = CGFloat(numberOfItems - 1) * itemSpacing
        return totalItemHeight + totalVerticalItemSpacing
    }

}
