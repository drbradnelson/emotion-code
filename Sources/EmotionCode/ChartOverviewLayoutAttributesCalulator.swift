import Foundation
import UIKit

class ChartOverviewLayoutAttributesCalulator {
    
    private let adapter: ChartOverviewCollectionLayoutDataAdapter
    private let layoutParams: ChartOverviewCollectionLayout.LayoutParams
    private let areaAllocator: ChartOverviewLayoutAreaAllocator
    
    private var _columnWidth: CGFloat?
    
    init(adapter: ChartOverviewCollectionLayoutDataAdapter, layoutParams: ChartOverviewCollectionLayout.LayoutParams, areaAllocator: ChartOverviewLayoutAreaAllocator) {
        self.adapter = adapter
        self.layoutParams = layoutParams
        self.areaAllocator = areaAllocator
    }
}

extension ChartOverviewLayoutAttributesCalulator {
    
    func calculateAttributesForColumnElementHeader() -> [NSIndexPath : UICollectionViewLayoutAttributes] {
        let columnHeaderElementHeight = self.layoutParams.heightForColumnHeaderElement
        let area = self.areaAllocator.allocateArea(withHeight: columnHeaderElementHeight)
        
        var attributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        for columnPosition in 0 ..< adapter.numberOfColumns() {
            
            let frame = self.calculateFrame(forColumntHeaderAtPosition: columnPosition, inArea:area)
            let indexPath = self.adapter.indexPath(forColumnPosition: columnPosition)
            
            let layoutAttribute = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier, withIndexPath: indexPath)
            layoutAttribute.frame = frame
            
            attributes[indexPath] = layoutAttribute
        }
        
        return attributes
    }
    
    func calculateAttributes(forSection section: Int) -> [String: [NSIndexPath : UICollectionViewLayoutAttributes]] {
        let sectionHeight = self.calculateHeight(forSection: section)
        let area = self.areaAllocator.allocateArea(withHeight: sectionHeight)
        
        var elementsAttributes = [NSIndexPath : UICollectionViewLayoutAttributes]()
        let counterAttributes = self.calculateAttributesForRowCounterElement(forSection: section, inArea: area)
        
        self.adapter.forEachItemPosition { (itemPosition) in
            let itemElementFrame = self.calculateFrameForItemElement(atPosition: itemPosition, inArea:area)
            let itemElementIndexPath = self.adapter.indexPath(forItemPosition: itemPosition)
            
            let itemElementAttributes = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: itemElementIndexPath)
            itemElementAttributes.frame = itemElementFrame
            elementsAttributes[itemElementIndexPath] = itemElementAttributes
        }
        
        let attributes = [
            ChartOverviewCollectionLayout.kRowCounterElementIdentifier : counterAttributes,
            ChartOverviewCollectionLayout.kItemElementIdentifier : elementsAttributes
        ]
        
        return attributes
    }
    
    func calculateAttributesForRowCounterElement(forSection section: Int, inArea area: CGRect) -> [NSIndexPath : UICollectionViewLayoutAttributes] {
        let rowPosition = section
        
        var counterAttributes: UICollectionViewLayoutAttributes
        let counterElementAttributeFrame = self.calculateFrameForCounterElement(atPosition: section, inArea:area)
        let counterElementIndexPath = self.adapter.indexPath(forRowPosition: rowPosition)
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
    private func calculateFrameForItemElement(atPosition position: ChartItemPosition, inArea area: CGRect) -> CGRect {
        let horizontalOffset = self.calculateHorizontalOffsetForElement(atPosition: position)
        let verticalOffset = self.calculateVerticalOffsetForElement(atPosition: position)
        
        let itemHeight = self.layoutParams.heightForItemElement
        let itemWidth = self.calculateColumnWidth()
        
        let frame = CGRect.init(
            x: CGRectGetMinX(area) + horizontalOffset,
            y: CGRectGetMinY(area) + verticalOffset,
            width: itemWidth,
            height: itemHeight
        )
        
        return frame
    }
    private func calculateColumnOffset() -> CGFloat {
        return self.layoutParams.widthForRowCounterElement
    }
    private func calculateHorizontalOffsetForElement(atPosition position: ChartItemPosition) -> CGFloat {
        let columnWidth = self.calculateColumnWidth()
        let columnSpacing = self.layoutParams.spacingBetweenRows
        let rowCounterWidth = self.layoutParams.widthForRowCounterElement
        
        let offset = rowCounterWidth + (columnSpacing + columnWidth) * CGFloat(position.columnPosition)
        return offset
    }
    private func calculateVerticalOffsetForElement(atPosition position: ChartItemPosition) -> CGFloat {
        let spacingBetweenItems = self.layoutParams.spacingBetweenItems
        let itemHeight = self.layoutParams.heightForItemElement
        
        let offset = (spacingBetweenItems + itemHeight) * CGFloat(position.itemPosition)
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
        let numberOfColumns = self.adapter.numberOfColumns()
        var maxRowsNumber = 0
        for columnPosition in 0 ..< numberOfColumns {
            
            let rowsNumber = self.adapter.numberOfRows(forColumn: columnPosition)
            if maxRowsNumber < rowsNumber {
                maxRowsNumber = rowsNumber
            }
        }
        
        let itemHeight = self.layoutParams.heightForItemElement
        let itemSpacing = self.layoutParams.spacingBetweenItems
        
        let height = itemHeight * CGFloat(maxRowsNumber) + itemSpacing * CGFloat(maxRowsNumber - 1)
        
        return height
    }
}