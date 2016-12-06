import Foundation

public protocol ChartLayout: DefaultChartLayout {}

public typealias DefaultChartLayout = Any
    & ChartData
    & ChartMode
    & ContentPadding
    & DefaultChartContentOffset
    & DefaultChartSize
    & DefaultHeaderFrames
    & DefaultHeaderPositions
    & DefaultHeaderSizes
    & DefaultItemFrames
    & DefaultItemPositions
    & DefaultItemSizes
    & DefaultItemSpacing
    & DefaultSectionHeights
    & DefaultSectionPositions
    & DefaultSectionSpacing
    & NumberOfColumns
    & ViewSize
