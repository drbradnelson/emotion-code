public protocol SectionSpacingCalculator {

    var mode: ChartLayoutMode { get }

}

public extension SectionSpacingCalculator {

    static var horizontalSectionSpacing: Float {
        return 5
    }

    var verticalSectionSpacing: Float {
        switch mode {
        case .all: return 5
        case .group, .emotion: return 20
        }
    }

}
