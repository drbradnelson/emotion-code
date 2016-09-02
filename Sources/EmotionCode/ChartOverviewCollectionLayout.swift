import Foundation
import UIKit

// MARK: Delegate

protocol ChartOverviewCollectionLayoutDelegate: NSObjectProtocol {
    func widthForRowCounterElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func heightForColumnHeaderElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat

    func heightForRowElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout, forRow row: Int) -> CGFloat

    func spacingBetweenColumns(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func spacingBetweenRows(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func spacingBetweenItems(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
}

// MARK: Main

class ChartOverviewCollectionLayout: UICollectionViewLayout {
    static let kColumnHeaderElementIdentifier = "ColumnHeader"
    static let kRowCounterElementIdentifier = "RowCounter"
    static let kRowElementIdentifier = "ChartRow"

    weak var delegate: ChartOverviewCollectionLayoutDelegate!
    var adapter: ChartOverviewCollectionLayoutDataAdapter!

    private var layoutAttributesList: [UICollectionViewLayoutAttributes]?
    private var layoutAttributesMap: [String : [NSIndexPath: UICollectionViewLayoutAttributes]]?

    private var calculatedContentSize: CGSize!
}

// MARK: Calculating layout

extension ChartOverviewCollectionLayout {
    override func prepareLayout() {
        var layoutAttributesList = [UICollectionViewLayoutAttributes]()

        let allocator = ChartOverviewLayoutAreaAllocator.init(areaWidth: self.layoutParams.availableWidth)
        let calculator = ChartOverviewLayoutAttributesCalculator.init(adapter: self.adapter, layoutParams: self.layoutParams, areaAllocator: allocator)

        let columnHeaderElementAttributesMap = self.calculateAttributesForColumnElementHeader(withCalculator: calculator)
        let (rowCounterElementsAttributes, rowElementsAttributes) = self.calculateSectionsAttributes(withCalculator: calculator, andAllocator: allocator)

        [columnHeaderElementAttributesMap, rowCounterElementsAttributes, rowElementsAttributes].forEach { (attributesMap) in
            layoutAttributesList.appendContentsOf(attributesMap.values)
        }

        self.layoutAttributesList = layoutAttributesList

        self.layoutAttributesMap = [
            ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier : columnHeaderElementAttributesMap,
            ChartOverviewCollectionLayout.kRowCounterElementIdentifier : rowCounterElementsAttributes,
            ChartOverviewCollectionLayout.kRowElementIdentifier : rowElementsAttributes,
        ]

        self.calculatedContentSize = CGSize.init(width: CGRectGetWidth(allocator.allocatedArea()), height: CGRectGetHeight(allocator.allocatedArea()))
    }

    private func calculateAttributesForColumnElementHeader(withCalculator calculator: ChartOverviewLayoutAttributesCalculator) -> [NSIndexPath: UICollectionViewLayoutAttributes] {
        let columnHeaderElementAttributesMap = calculator.calculateAttributesForColumnElementHeader()
        return columnHeaderElementAttributesMap
    }

    private func calculateSectionsAttributes(withCalculator calculator: ChartOverviewLayoutAttributesCalculator, andAllocator allocator: ChartOverviewLayoutAreaAllocator) -> (rowCounterElementsAttributes: [NSIndexPath: UICollectionViewLayoutAttributes], rowElementsAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]) {

        var rowCounterElementAttributesMap = [NSIndexPath: UICollectionViewLayoutAttributes]()
        var rowElementAttributesMap = [NSIndexPath: UICollectionViewLayoutAttributes]()

        let interRowSpacing = self.layoutParams.spacingBetweenRows
        for section in 0 ..< self.adapter.numberOfSections() {
            let sectionAttributes = calculator.calculateAttributes(forSection: section)

            let sectionRowCounterAttributes = sectionAttributes[ChartOverviewCollectionLayout.kRowCounterElementIdentifier]!
            let sectionRowAttributes = sectionAttributes[ChartOverviewCollectionLayout.kRowElementIdentifier]!

            rowCounterElementAttributesMap.mergeWith(sectionRowCounterAttributes)
            rowElementAttributesMap.mergeWith(sectionRowAttributes)

            allocator.allocateArea(withHeight: interRowSpacing)
        }

        return (rowCounterElementAttributesMap, rowElementAttributesMap)
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func collectionViewContentSize() -> CGSize {
        return self.calculatedContentSize
    }
}

// MARK: Providing layout attributes

extension ChartOverviewCollectionLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = self.layoutAttributesList?.filter({ (attribute) -> Bool in
            CGRectIntersectsRect(attribute.frame, rect)
        })

        return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = self.layoutAttributesMap![ChartOverviewCollectionLayout.kRowElementIdentifier]![indexPath]
        return attributes
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = self.layoutAttributesMap![elementKind]![indexPath]
        return attributes
    }
}
