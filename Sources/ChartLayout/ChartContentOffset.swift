import Foundation

public protocol ChartContentOffset {

    var verticalContentOffset: Float? { get }

}

public extension ChartContentOffset where Self: DefaultChartContentOffset {

    var verticalContentOffset: Float? {
        switch mode {
        case .all: return nil
        case .section(let section):
            return yPosition(forSection: section) - verticalSectionSpacing
        case .emotion(let indexPath):
            return yPositionForItem(at: indexPath) - verticalSectionSpacing
        }
    }

}

public typealias DefaultChartContentOffset = ChartContentOffset
    & ChartMode
    & SectionPositions
    & SectionSpacing
    & ItemPositions
