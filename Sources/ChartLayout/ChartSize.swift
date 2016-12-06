public protocol ChartSize {

    var chartSize: Size { get }

}

public extension ChartSize where Self: DefaultChartSize {

    var chartSize: Size {
        let lastSection = numberOfSections - 1
        let collectionViewContentHeight = yPosition(forSection: lastSection) + maximumSectionHeights
        let height = collectionViewContentHeight + verticalSectionSpacing + contentPadding
        let width: Float
        switch mode {
        case .all:
            width = viewWidth
        case .section, .emotion:
            width = viewWidth * Float(Self.numberOfColumns) - contentPadding + rowHeaderSizes.width
        }
        return Size(width: width, height: height)
    }

}

public typealias DefaultChartSize = ChartSize
    & ChartMode
    & ContentPadding
    & HeaderSizes
    & NumberOfColumns
    & NumberOfSections
    & SectionHeights
    & SectionPositions
    & SectionSpacing
    & ViewWidth
