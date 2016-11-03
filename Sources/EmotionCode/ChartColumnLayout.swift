import UIKit

final class ChartColumnLayout: UICollectionViewLayout {

    // MARK: Parametrization

    private let numberOfColumns = 2
    private let contentPadding: CGFloat = 20
    private let itemSpacing: CGFloat = 10

    private func itemHeight(for section: Int) -> CGFloat {
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
        return CGSize(width: collectionView.bounds.width * 2 - contentPadding, height: collectionViewContentHeight + verticalSectionSpacing)
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
        let layoutAttributes = collectionView.indexPaths.flatMap(layoutAttributesForItem)
        return layoutAttributes.filter { layoutAttributes in layoutAttributes.frame.intersects(rect) }
    }

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
        let column = (indexPath.section + numberOfColumns) % numberOfColumns
        return contentPadding + CGFloat(column) * (itemWidth + contentPadding)
    }

    private func yOffsetForLayoutAttributes(at indexPath: IndexPath) -> CGFloat {
        let height = itemHeight(for: indexPath.section)
        let cumulativeContentHeight = CGFloat(indexPath.item) * height
        let cumulativeSpacingHeight = CGFloat(indexPath.item) * itemSpacing
        return yOffset(forSection: indexPath.section) + cumulativeContentHeight + cumulativeSpacingHeight
    }

    private func yOffset(forSection section: Int) -> CGFloat {
        let row = section / numberOfColumns
        let cumulativeContentHeight = maximumSectionHeight * CGFloat(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * CGFloat(row)
        return verticalSectionSpacing + cumulativeContentHeight + cumulativeSpacingHeight
    }

    // MARK: Item size

    private func itemSize(forSection section: Int) -> CGSize {
        let height = itemHeight(for: section)
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
        let totalItemHeight = CGFloat(numberOfItems) * itemHeight(for: section)
        let totalVerticalItemSpacing = CGFloat(numberOfItems - 1) * itemSpacing
        return totalItemHeight + totalVerticalItemSpacing
    }

}

extension UICollectionView {

    var visibleContentHeight: CGFloat {
        return bounds.height - contentInset.top - contentInset.bottom
    }

}
