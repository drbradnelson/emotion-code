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

    private var itemSize: CGSize! {
        let totalPadding = 2 * sectionPadding
        let width = columnWidth - totalPadding
        let height = 60 / CGFloat(numberOfColumns)

        return CGSize(width: width, height: height)
    }

    private var yOffsets: [[CGFloat]]!

    // MARK: Cache for storing attributes

    private var cache = [UICollectionViewLayoutAttributes]()

    // MARK: Collection view layout

    override func prepare() {
        guard cache.isEmpty else { return }

        calculateYOffsets()
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = layoutAttributes(for: indexPath)
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
        return layoutAttributes(for: indexPath)
    }

    // MARK: Get layout attributes for index path

    private func layoutAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let column = columnIndex(for: indexPath.section)

        let xOffset = CGFloat(column) * columnWidth + sectionPadding

        let point = CGPoint(x: xOffset, y: yOffsets[indexPath.section][indexPath.item])
        let frame = CGRect(origin: point, size: itemSize)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

    // MARK: Calculate properties

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

            let column = columnIndex(for: section)
            if column == numberOfColumns - 1 {
                contentHeight = itemOffset
            }

            yOffsets.append(offsets)
        }
        contentHeight += sectionPadding
    }

    private func columnIndex(for section: Int) -> Int {
        return (section + numberOfColumns) % numberOfColumns
    }

}
