import Foundation

public protocol ChartContentOffsetCalculator {

    var mode: ChartLayoutMode { get }

    func yPosition(forSection section: Int) -> Float
    func yPositionForItem(at indexPath: IndexPath) -> Float

    var verticalSectionSpacing: Float { get }

}

public extension ChartContentOffsetCalculator {

    var verticalContentOffset: Float? {
        switch mode {
        case .all: return nil
        case .group(let section):
            return yPosition(forSection: section) - verticalSectionSpacing
        case .emotion(let indexPath):
            return yPositionForItem(at: indexPath) - verticalSectionSpacing
        }
    }

}
