import UIKit

final class ChartLayout: UICollectionViewLayout {

    private let numberOfColumns = 2

    private let itemPadding: CGFloat = 5
    private let sectionPadding: CGFloat = 15

    private var contentHeight: CGFloat = 0

    private var columnWidth: CGFloat {
        return collectionViewContentSize.width / CGFloat(numberOfColumns)
    }

    private var itemSize: CGSize {
        let totalPadding = 2 * sectionPadding
        let width = collectionViewContentSize.width - totalPadding / CGFloat(numberOfColumns)
        let height = 60 / CGFloat(numberOfColumns)

        return CGSize(width: width, height: height)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }

    private var xOffsets: [CGFloat] {
        return (0..<numberOfColumns).map { column in
            CGFloat(column) * column + sectionPadding
        }
    }

    private var yOffsets: [[CGFloat]] {
        var yOffsets: [[CGFloat]] = []

        for section in 0..<collectionView!.numberOfSections {
            var offsets: [CGFloat] = []
            var itemOffset = contentHeight

            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let padding = (item == 0) ? sectionPadding : itemPadding
                itemOffset += padding
                offsets.append(itemOffset)
                itemOffset += itemSize.height
            }
            yOffsets.append(offsets)

            let columnIndex = (section + numberOfColumns) % numberOfColumns
            if (columnIndex + 1 == numberOfColumns) {
                contentHeight = itemOffset
            }
        }
        contentHeight += sectionPadding

        return yOffsets
    }

}
