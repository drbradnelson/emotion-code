public protocol ChartSizeCalculator {

    var chartSize: Size { get }

}

public extension ChartSizeCalculator where Self: DefaultChartSizeCalculator {

    var chartSize: Size {
        let lastSection = numberOfSections - 1
        let collectionViewContentHeight = yPosition(forSection: lastSection) + maximumSectionHeight
        let height = collectionViewContentHeight + verticalSectionSpacing + contentPadding
        let width: Float
        switch mode {
        case .all:
            width = viewWidth
        case .section, .emotion:
            width = viewWidth * Float(Self.numberOfColumns) - contentPadding + rowHeaderSize.width
        }
        return Size(width: width, height: height)
    }

}

public typealias DefaultChartSizeCalculator = ChartSizeCalculator
    & ChartModeProvider
    & ContentPaddingProvider
    & HeaderSizeCalculator
    & NumberOfColumnsProvider
    & NumberOfSectionsProvider
    & SectionHeightCalculator
    & SectionPositionCalculator
    & SectionSpacingCalculator
    & ViewWidthProvider
