import UIKit

final class ChartLayout: UICollectionViewLayout {

    private let numberOfColumns = 2

    private let itemPadding: CGFloat = 5
    private let sectionPadding: CGFloat = 15

    private var contentHeight: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }

    // MARK: Properties for collection view layout attributes

    private var columnWidth: CGFloat {
        return collectionViewContentSize.width / CGFloat(numberOfColumns)
    }

    private var itemSize: CGSize {
        let totalPadding = 2 * sectionPadding
        let width = columnWidth - totalPadding
        let height = 60 / CGFloat(numberOfColumns)

        return CGSize(width: width, height: height)
    }

    private var sectionHeight: CGFloat {
        let items = CGFloat(collectionView!.numberOfItems(inSection: 0))
        let padding = (items - 1) * itemPadding + sectionPadding
        let itemHeights = itemSize.height * items
        return padding + itemHeights
    }

    // MARK: Cache for storing attributes

    private var cache = [UICollectionViewLayoutAttributes]()

    // MARK: Collection view layout

    override func prepare() {
        guard cache.isEmpty else { return }

        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = layoutAttributesForItem(at: indexPath)!
                cache.append(attributes)
            }
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if collectionView!.bounds != newBounds {
            cache = []
            return true
        }
        return false
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let column = columnIndex(for: indexPath.section)

        let xOffset = CGFloat(column) * columnWidth + sectionPadding

        let point = CGPoint(x: xOffset, y: yOffset(at: indexPath))
        let frame = CGRect(origin: point, size: itemSize)
        contentHeight = max(contentHeight, frame.maxY)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

    // MARK: Calculate properties

    private func yOffset(at indexPath: IndexPath) -> CGFloat {
        let line = indexPath.section / numberOfColumns
        let sectionOffset = CGFloat(line) * sectionHeight

        let padding = CGFloat(indexPath.item) * itemPadding + sectionPadding
        let itemOffset = CGFloat(indexPath.item) * itemSize.height + padding

        return itemOffset + sectionOffset
    }

    private func columnIndex(for section: Int) -> Int {
        return (section + numberOfColumns) % numberOfColumns
    }

}
