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
        let columnHeaderElementHeight = self.layoutParams.heightForColumnHeaderElement
        let area = self.areaAllocator.allocateArea(withHeight: columnHeaderElementHeight)

        var attributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        for columnIndex in 0 ..< adapter.numberOfColumns() {

            let frame = self.calculateFrame(forColumntHeaderAtPosition: columnIndex, inArea:area)
            let indexPath = self.adapter.indexPath(forColumnIndex: columnIndex)

            let layoutAttribute = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier, withIndexPath: indexPath)
            layoutAttribute.frame = frame

            attributes[indexPath] = layoutAttribute
        }

        return attributes
    }

    func calculateAttributes(forSection section: Int) -> [String: [NSIndexPath : UICollectionViewLayoutAttributes]] {
        let sectionHeight = self.calculateHeight(forSection: section)
        let area = self.areaAllocator.allocateArea(withHeight: sectionHeight)

        var rowElementAttributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        let counterAttributes = self.calculateAttributesForRowCounterElement(forSection: section, inArea: area)

        for columnIndex in 0 ..< self.adapter.numberOfColumns() {
            let rowPosition = ChartRowPosition.init(column: columnIndex, row: section)
            let rowElementFrame = self.calculateFrameForRowElement(forRowPosition: rowPosition, inArea:area)
            let rowElementIndexPath = self.adapter.indexPath(forRowPosition: rowPosition)

            let rowAttributes = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: rowElementIndexPath)
            rowAttributes.frame = rowElementFrame
            rowElementAttributes[rowElementIndexPath] = rowAttributes
        }

        let attributes = [
            ChartOverviewCollectionLayout.kRowCounterElementIdentifier : counterAttributes,
            ChartOverviewCollectionLayout.kRowElementIdentifier : rowElementAttributes
        ]

        return attributes
    }

    func calculateAttributesForRowCounterElement(forSection section: Int, inArea area: CGRect) -> [NSIndexPath : UICollectionViewLayoutAttributes] {
        let rowIndex = section

        var counterAttributes: UICollectionViewLayoutAttributes
        let counterElementAttributeFrame = self.calculateFrameForCounterElement(atPosition: section, inArea:area)
        let counterElementIndexPath = self.adapter.indexPath(forRowIndex: rowIndex)
        counterAttributes = UICollectionViewLayoutAttributes.init(
            forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kRowCounterElementIdentifier,
            withIndexPath: counterElementIndexPath
        )

        counterAttributes.frame = counterElementAttributeFrame

        return [counterElementIndexPath : counterAttributes]
    }

    private func calculateFrame(forColumntHeaderAtPosition position: Int, inArea area: CGRect) -> CGRect {
        let offset = self.calculateColumnOffset()
        let columnWidth = self.calculateColumnWidth()
        let headerHeight = self.layoutParams.heightForColumnHeaderElement

        let startPosition = offset + CGFloat(position) * (self.layoutParams.spacingBetweenColumns + columnWidth)

        let frame = CGRect.init(x: CGRectGetMinX(area) + startPosition, y: CGRectGetMinY(area), width: columnWidth, height: headerHeight)
        return frame
    }

    private func calculateFrameForCounterElement(atPosition position: Int, inArea area: CGRect) -> CGRect {
        let counterElementWidth = self.layoutParams.widthForRowCounterElement

        let frame = CGRect.init (x: 0, y: CGRectGetMinY(area), width: counterElementWidth, height: CGRectGetHeight(area))
        return frame
    }

    private func calculateFrameForRowElement(forRowPosition position: ChartRowPosition, inArea area: CGRect) -> CGRect {
        let horizontalOffset = self.calculateHorizontalOffsetForRow(atPosition: position)
        let verticalOffset = self.calculateVerticalOffsetForRow(atPosition: position)

        let rowHeight = self.layoutParams.heightForRowElement(forRow: position.rowIndex)
        let rowWidth = self.calculateColumnWidth()

        let frame = CGRect.init(
            x: CGRectGetMinX(area) + horizontalOffset,
            y: CGRectGetMinY(area) + verticalOffset,
            width: rowWidth,
            height: rowHeight
        )

        return frame
    }

    private func calculateColumnOffset() -> CGFloat {
        return self.layoutParams.widthForRowCounterElement
    }

    private func calculateHorizontalOffsetForRow(atPosition position: ChartRowPosition) -> CGFloat {
        let columnWidth = self.calculateColumnWidth()
        let columnSpacing = self.layoutParams.spacingBetweenRows
        let rowCounterWidth = self.layoutParams.widthForRowCounterElement

        let offset = rowCounterWidth + (columnSpacing + columnWidth) * CGFloat(position.columnIndex)
        return offset
    }

    private func calculateVerticalOffsetForRow(atPosition position: ChartRowPosition) -> CGFloat {
        let offset: CGFloat = 0
        return offset
    }

    private func calculateColumnWidth() -> CGFloat {
        if _columnWidth == nil {
            let rowCounterElementWidth = self.layoutParams.widthForRowCounterElement
            let numberOfColumns = self.adapter.numberOfColumns()
            let interColumnsSpacing = self.layoutParams.spacingBetweenColumns
            let availableColumnsWidth = (self.layoutParams.availableWidth - rowCounterElementWidth) - CGFloat(numberOfColumns - 1) * interColumnsSpacing
            _columnWidth = availableColumnsWidth / CGFloat(numberOfColumns)

        }

        return _columnWidth!
    }
    private func calculateHeight(forSection section: Int) -> CGFloat {
        let rowIndex = section
        let rowHeight = self.layoutParams.heightForRowElement(forRow: rowIndex)
        return rowHeight
    }
}
