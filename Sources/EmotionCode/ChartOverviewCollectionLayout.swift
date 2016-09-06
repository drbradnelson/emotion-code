import UIKit

// MARK: Delegate

protocol ChartOverviewCollectionLayoutDelegate: class {
    func widthForRowCounterElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func heightForColumnHeaderElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat

    func heightForRowElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout, forRow row: Int) -> CGFloat

    func spacingBetweenColumns(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func spacingBetweenRows(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat
    func spacingBetweenItems(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat

    func insetsForContent(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> UIEdgeInsets
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

        let contentInsets = delegate.insetsForContent(inCollectionView: collectionView!, layout: self)
        let allocator = ChartOverviewLayoutAreaAllocator.init(areaWidth: layoutParams.availableWidth, andInsets: contentInsets)
        let calculator = ChartOverviewLayoutAttributesCalculator.init(adapter: adapter, layoutParams: layoutParams, areaAllocator: allocator)

        let columnHeaderElementAttributesMap = calculateAttributesForColumnElementHeader(withCalculator: calculator)
        let (rowCounterElementsAttributes, rowElementsAttributes) = calculateSectionsAttributes(withCalculator: calculator, andAllocator: allocator)

        [columnHeaderElementAttributesMap, rowCounterElementsAttributes, rowElementsAttributes].forEach { (attributesMap) in
            layoutAttributesList.appendContentsOf(attributesMap.values)
        }

        self.layoutAttributesList = layoutAttributesList

        layoutAttributesMap = [
            ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier : columnHeaderElementAttributesMap,
            ChartOverviewCollectionLayout.kRowCounterElementIdentifier : rowCounterElementsAttributes,
            ChartOverviewCollectionLayout.kRowElementIdentifier : rowElementsAttributes,
        ]

        calculatedContentSize = CGSize.init(width: allocator.allocatedArea().width, height: allocator.allocatedArea().height)
    }

    private func calculateAttributesForColumnElementHeader(withCalculator calculator: ChartOverviewLayoutAttributesCalculator) -> [NSIndexPath: UICollectionViewLayoutAttributes] {
        let columnHeaderElementAttributesMap = calculator.calculateAttributesForColumnElementHeader()
        return columnHeaderElementAttributesMap
    }

    private func calculateSectionsAttributes(withCalculator calculator: ChartOverviewLayoutAttributesCalculator, andAllocator allocator: ChartOverviewLayoutAreaAllocator) -> (rowCounterElementsAttributes: [NSIndexPath: UICollectionViewLayoutAttributes], rowElementsAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]) {

        var rowCounterElementAttributesMap = [NSIndexPath: UICollectionViewLayoutAttributes]()
        var rowElementAttributesMap = [NSIndexPath: UICollectionViewLayoutAttributes]()

        let interRowSpacing = layoutParams.spacingBetweenRows
        for section in 0 ..< adapter.numberOfSections() {
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
        return calculatedContentSize
    }
}

// MARK: Providing layout attributes

extension ChartOverviewCollectionLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = layoutAttributesList?.filter({ (attribute) -> Bool in
            return attribute.frame.intersects(rect)
        })

        return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesMap![ChartOverviewCollectionLayout.kRowElementIdentifier]![indexPath]
        return attributes
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesMap![elementKind]![indexPath]
        return attributes
    }
}
