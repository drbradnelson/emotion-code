public protocol ItemSpacingCalculator {

    var mode: ChartLayoutMode { get }
    var verticalSectionSpacing: Float { get }

}

public extension ItemSpacingCalculator {

    var itemSpacing: Float {
        switch mode {
        case .all: return 0
        case .group: return 10
        case .emotion: return verticalSectionSpacing
        }
    }

}
