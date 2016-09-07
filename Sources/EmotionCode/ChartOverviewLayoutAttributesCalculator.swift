import Foundation
import UIKit

final class ChartOverviewLayoutAttributesCalculator {

    private let adapter: ChartOverviewCollectionLayoutDataAdapter
    private let layoutParams: ChartOverviewLayoutParams
    private let areaAllocator: ChartOverviewLayoutAreaAllocator

    private var _columnWidth: CGFloat?

    init(adapter: ChartOverviewCollectionLayoutDataAdapter, layoutParams: ChartOverviewLayoutParams, areaAllocator: ChartOverviewLayoutAreaAllocator) {
        self.adapter = adapter
        self.layoutParams = layoutParams
        self.areaAllocator = areaAllocator
    }

}

extension ChartOverviewLayoutAttributesCalculator {

    func calculateAttributesForColumnElementHeader() -> [NSIndexPath : UICollectionViewLayoutAttributes] {
        let columnHeaderElementHeight = layoutParams.heightForColumnHeaderElement
        let area = areaAllocator.allocateArea(withHeight: columnHeaderElementHeight)

        var attributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        for columnIndex in 0 ..< adapter.numberOfColumns() {

            let frame = calculateFrame(forColumntHeaderAtPosition: columnIndex, inArea:area)
            let indexPath = adapter.indexPath(forColumnIndex: columnIndex)

            let layoutAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ChartOverviewCollectionLayout.columnHeaderElementIdentifier, withIndexPath: indexPath)
            layoutAttribute.frame = frame

            attributes[indexPath] = layoutAttribute
        }

        return attributes
    }

    func calculateAttributes(forSection section: Int) -> [String: [NSIndexPath : UICollectionViewLayoutAttributes]] {
        let sectionHeight = calculateHeight(forSection: section)
        let area = areaAllocator.allocateArea(withHeight: sectionHeight)

        var rowElementAttributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        let counterAttributes = calculateAttributesForRowCounterElement(forSection: section, inArea: area)

        for columnIndex in 0 ..< adapter.numberOfColumns() {
            let rowPosition = ChartRowPosition(column: columnIndex, row: section)
            let rowElementFrame = calculateFrameForRowElement(forRowPosition: rowPosition, inArea:area)
            let rowElementIndexPath = adapter.indexPath(forRowPosition: rowPosition)

            let rowAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: rowElementIndexPath)
            rowAttributes.frame = rowElementFrame
            rowElementAttributes[rowElementIndexPath] = rowAttributes
        }

        let attributes = [
            ChartOverviewCollectionLayout.cowCounterElementIdentifier: counterAttributes,
            ChartOverviewCollectionLayout.rowElementIdentifier: rowElementAttributes
        ]

        return attributes
    }

    func calculateAttributesForRowCounterElement(forSection section: Int, inArea area: CGRect) -> [NSIndexPath : UICollectionViewLayoutAttributes] {
        let rowIndex = section

        var counterAttributes: UICollectionViewLayoutAttributes
        let counterElementAttributeFrame = calculateFrameForCounterElement(atPosition: section, inArea:area)
        let counterElementIndexPath = adapter.indexPath(forRowIndex: rowIndex)
        counterAttributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: ChartOverviewCollectionLayout.cowCounterElementIdentifier,
            withIndexPath: counterElementIndexPath
        )

        counterAttributes.frame = counterElementAttributeFrame

        return [counterElementIndexPath : counterAttributes]
    }

    private func calculateFrame(forColumntHeaderAtPosition position: Int, inArea area: CGRect) -> CGRect {
        let offset = calculateColumnOffset(forColumnIndex: position)
        let columnWidth = calculateColumnWidth()
        let headerHeight = layoutParams.heightForColumnHeaderElement

        let frame = CGRect(x: area.minX + offset, y: area.minY, width: columnWidth, height: headerHeight)
        return frame
    }

    private func calculateFrameForCounterElement(atPosition position: Int, inArea area: CGRect) -> CGRect {
        let counterElementWidth = layoutParams.widthForRowCounterElement

        let frame = CGRect(x: 0, y: area.minY, width: counterElementWidth, height: area.height)
        return frame
    }

    private func calculateFrameForRowElement(forRowPosition position: ChartRowPosition, inArea area: CGRect) -> CGRect {
        let horizontalOffset = calculateHorizontalOffsetForRow(atPosition: position)
        let verticalOffset = calculateVerticalOffsetForRow(atPosition: position)

        let rowHeight = layoutParams.heightForRowElement(forRow: position.rowIndex)
        let rowWidth = calculateColumnWidth()

        let frame = CGRect(
            x: area.minX + horizontalOffset,
            y: area.minY + verticalOffset,
            width: rowWidth,
            height: rowHeight
        )

        return frame
    }

    private func calculateColumnOffset(forColumnIndex column: Int) -> CGFloat {

        let initialOffset = layoutParams.widthForRowCounterElement
        let columnWidth = calculateColumnWidth()
        let spacing = layoutParams.spacingBetweenColumns

        let startPosition = initialOffset + CGFloat(column) * (spacing + columnWidth)
        return startPosition
    }

    private func calculateHorizontalOffsetForRow(atPosition position: ChartRowPosition) -> CGFloat {
        let offset = calculateColumnOffset(forColumnIndex: position.columnIndex)
        return offset
    }

    private func calculateVerticalOffsetForRow(atPosition position: ChartRowPosition) -> CGFloat {
        let offset: CGFloat = 0
        return offset
    }

    private func calculateColumnWidth() -> CGFloat {
        if _columnWidth == nil {
            let rowCounterElementWidth = layoutParams.widthForRowCounterElement
            let numberOfColumns = adapter.numberOfColumns()
            let interColumnsSpacing = layoutParams.spacingBetweenColumns
            let availableColumnsWidth = (layoutParams.availableWidth - rowCounterElementWidth) - CGFloat(numberOfColumns - 1) * interColumnsSpacing - layoutParams.contentInsets.left - layoutParams.contentInsets.right
            _columnWidth = availableColumnsWidth / CGFloat(numberOfColumns)

        }

        return _columnWidth!
    }

    private func calculateHeight(forSection section: Int) -> CGFloat {
        let rowIndex = section
        let rowHeight = layoutParams.heightForRowElement(forRow: rowIndex)
        return rowHeight
    }

}
