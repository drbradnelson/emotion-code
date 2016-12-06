import Foundation

public protocol ChartContentOffsetCalculator {

    var verticalContentOffset: Float? { get }

}

public extension ChartContentOffsetCalculator where Self: DefaultChartContentOffsetCalculator {

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

public typealias DefaultChartContentOffsetCalculator = ChartContentOffsetCalculator
    & ChartModeProvider
    & SectionPositionCalculator
    & SectionSpacingCalculator
    & ItemPositionCalculator
