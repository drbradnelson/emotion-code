import UIKit

// MARK: Main

class ChartFlowLayout: UICollectionViewLayout {

    private var cellAttributes = [NSIndexPath: UICollectionViewLayoutAttributes]()
    private var footerAttributes = [NSIndexPath: UICollectionViewLayoutAttributes]()
    private var contentSize: CGSize?

    private let numberOfVisibleRows = 20
    private let headerWidth = CGFloat(80)
    private let verticalDividerWidth = CGFloat(2)
    private let horizontalDividerHeight = CGFloat(2)

}

// MARK: Layout setup

extension ChartFlowLayout {
//swiftlint:disable function_body_length
    override func prepareLayout() {
        var rowY: CGFloat = 0

        let availableHeight = collectionView!.bounds.height
            - CGFloat(numberOfVisibleRows - 1) * horizontalDividerHeight
        let rowHeight = availableHeight / CGFloat(numberOfVisibleRows)

        for section in 0..<self.collectionView!.numberOfSections() {
            rowY = CGFloat(section) * (rowHeight + horizontalDividerHeight) + rowHeight
            var cellX = headerWidth

            if section%5 == 0 {
                let rowHeaderHeight = (rowHeight * 5) + (horizontalDividerHeight * 4 )
                let footerIndexPath = NSIndexPath(forItem: 0, inSection: section)
                let footerRowAttributes =
                UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                    withIndexPath: footerIndexPath)
                footerRowAttributes.frame = CGRect(x: 0, y: rowY, width: headerWidth, height: rowHeaderHeight)
                footerAttributes[footerIndexPath] = footerRowAttributes
            }

            for item in 0..<self.collectionView!.numberOfItemsInSection(section) {
                let cellWidth = CGFloat(collectionView!.bounds.width - headerWidth - verticalDividerWidth) / 2

                let cellIndexPath = NSIndexPath(forItem: item, inSection: section)
                let timeEntryCellAttributes =
                    UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndexPath)
                cellAttributes[cellIndexPath] = timeEntryCellAttributes
                timeEntryCellAttributes.frame = CGRect(x: cellX, y: rowY, width: cellWidth, height: rowHeight)

                cellX += cellWidth + verticalDividerWidth
                }
            }

        let maxY = rowY + rowHeight
        contentSize = CGSize(width: collectionView!.bounds.width, height: maxY)
    }

    override func collectionViewContentSize() -> CGSize {
        return contentSize!
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) ->
        [UICollectionViewLayoutAttributes]? {
            var attributes = [UICollectionViewLayoutAttributes]()
            for attribute in footerAttributes.values {
                if attribute.frame.intersects(rect) {
                    attributes.append(attribute)
                }
            }

            for attribute in cellAttributes.values {
                if attribute.frame.intersects(rect) {
                    attributes.append(attribute)
                }
            }
            return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) ->
        UICollectionViewLayoutAttributes? {
            return cellAttributes[indexPath]
    }

}
