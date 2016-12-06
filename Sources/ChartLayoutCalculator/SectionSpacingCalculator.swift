public protocol SectionSpacingCalculator {

    var horizontalSectionSpacing: Float { get }
    var verticalSectionSpacing: Float { get }

}

public extension SectionSpacingCalculator where Self: DefaultSectionSpacingCalculator {

    var horizontalSectionSpacing: Float {
        return 15
    }

    var verticalSectionSpacing: Float {
        switch mode {
        case .all: return 15
        case .section, .emotion: return 20
        }
    }

}

public typealias DefaultSectionSpacingCalculator = SectionSpacingCalculator
    & ChartModeProvider
