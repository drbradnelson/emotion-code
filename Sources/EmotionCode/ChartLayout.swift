import UIKit

final class ChartLayout: UICollectionViewLayout {

    private let numberOfColumns = 2

    private let itemPadding: CGFloat = 5
    private let sectionPadding: CGFloat = 15

    override var collectionViewContentSize: CGSize {
        let line = CGFloat(collectionView!.numberOfSections / numberOfColumns)
        let contentHeight = line * sectionHeight + sectionPadding
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }

    // MARK: Properties for collection view layout attributes

    private var columnWidth: CGFloat {
        return collectionView!.bounds.width / CGFloat(numberOfColumns)
    }

    private var itemSize: CGSize {
        let totalPadding = 2 * sectionPadding
        let width = columnWidth - totalPadding

        return CGSize(width: width, height: 30)
    }

    private var sectionHeight: CGFloat {
        let items: CGFloat = 5
        let padding = itemPadding * (items - 1) + sectionPadding
        let itemHeights = itemSize.height * items
        return padding + itemHeights
    }

    // MARK: Collection view layout

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView!.bounds != newBounds
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = layoutAttributesForItem(at: indexPath)!
                if attributes.frame.intersects(rect) { attributesArray.append(attributes) }
            }
        }

        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let point = location(at: indexPath)
        let frame = CGRect(origin: point, size: itemSize)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

    // MARK: Calculate properties

    private func location(at indexPath: IndexPath) -> CGPoint {
        let line = indexPath.section / numberOfColumns
        let sectionOffset = CGFloat(line) * sectionHeight

        let padding = CGFloat(indexPath.item) * itemPadding + sectionPadding
        let itemOffset = CGFloat(indexPath.item) * itemSize.height + padding

        let yOffset = itemOffset + sectionOffset

        let column = columnIndex(for: indexPath.section)
        let xOffset = CGFloat(column) * columnWidth + sectionPadding

        return CGPoint(x: xOffset, y: yOffset)
    }

    private func columnIndex(for section: Int) -> Int {
        return (section + numberOfColumns) % numberOfColumns
    }

}
