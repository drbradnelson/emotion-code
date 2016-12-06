import Foundation

public protocol ChartLayoutCalculator: DefaultChartLayoutCalculator {}

public typealias DefaultChartLayoutCalculator = Any
    & ChartDataProvider
    & ChartModeProvider
    & ContentPaddingProvider
    & DefaultChartContentOffsetCalculator
    & DefaultChartSizeCalculator
    & DefaultHeaderFrameCalculator
    & DefaultHeaderPositionCalculator
    & DefaultHeaderSizeCalculator
    & DefaultItemFrameCalculator
    & DefaultItemPositionCalculator
    & DefaultItemSizeCalculator
    & DefaultItemSpacingCalculator
    & DefaultSectionHeightCalculator
    & DefaultSectionPositionCalculator
    & DefaultSectionSpacingCalculator
    & NumberOfColumnsProvider
    & ViewSizeProvider
