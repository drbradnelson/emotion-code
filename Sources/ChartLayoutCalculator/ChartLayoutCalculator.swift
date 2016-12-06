import Foundation

public typealias HeaderCalculator = HeaderFrameCalculator & HeaderPositionCalculator & HeaderSizeCalculator
public typealias ItemCalculator = ItemFrameCalculator & ItemSizeCalculator & ItemPositionCalculator & ItemSpacingCalculator
public typealias SectionCalculator = SectionHeightCalculator & SectionSpacingCalculator & SectionPositionCalculator

public enum ChartLayoutMode {
    case all
    case section(Int)
    case emotion(IndexPath)
}

public protocol ChartLayoutCalculator: HeaderCalculator, ItemCalculator, SectionCalculator, ChartSizeCalculator, ChartContentOffsetCalculator {

    var mode: ChartLayoutMode { get }

}

public extension ChartLayoutCalculator {

    static var numberOfColumns: Int {
        return 2
    }

    var contentPadding: Float {
        switch mode {
        case .all: return 10
        case .section, .emotion: return 20
        }
    }

}
