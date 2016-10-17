import UIKit

final class ChartLayout: UICollectionViewLayout {

    private let numberOfColumns = 2

    private let itemPadding: CGFloat = 5
    private let sectionPadding: CGFloat = 15

    private var contentHeight: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }

    private var columnWidth: CGFloat {
        return collectionViewContentSize.width / CGFloat(numberOfColumns)
    }

    private var itemSize: CGSize!

    private var xOffsets: [CGFloat]!
    private var yOffsets: [[CGFloat]]!

    private var cache = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        guard cache.isEmpty else { return }

        calculateItemSize()
        calculateXOffsets()
        calculateYOffsets()
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = layoutAttributes(for: indexPath)
                cache.append(attributes)
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    private func layoutAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let column = (indexPath.section + numberOfColumns) % numberOfColumns

        let point = CGPoint(x: xOffsets[column], y: yOffsets[indexPath.section][indexPath.item])
        let frame = CGRect(origin: point, size: itemSize)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

    private func calculateItemSize() {
        let totalPadding = 2 * sectionPadding
        let width = columnWidth - totalPadding
        let height = 60 / CGFloat(numberOfColumns)

        itemSize = CGSize(width: width, height: height)
    }

    private func calculateXOffsets() {
        xOffsets = (0..<numberOfColumns).map { column in
            CGFloat(column) * columnWidth + sectionPadding
        }
    }

    private func calculateYOffsets() {
        yOffsets = []
        contentHeight = 0

        for section in 0..<collectionView!.numberOfSections {
            var offsets: [CGFloat] = []
            var itemOffset = contentHeight

            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let padding = (item == 0) ? sectionPadding : itemPadding
                itemOffset += padding
                offsets.append(itemOffset)
                itemOffset += itemSize.height
            }

            if (section + numberOfColumns + 1) % numberOfColumns == 0 {
                contentHeight = itemOffset
            }

            yOffsets.append(offsets)
        }
        contentHeight += sectionPadding
    }

}
