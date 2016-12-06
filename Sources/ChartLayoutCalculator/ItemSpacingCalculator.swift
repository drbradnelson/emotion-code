public protocol ItemSpacingCalculator {

    var itemSpacing: Float { get }

}

public extension ItemSpacingCalculator where Self: DefaultItemSpacingCalculator {

    var itemSpacing: Float {
        switch mode {
        case .all: return 5
        case .section: return 10
        case .emotion: return verticalSectionSpacing
        }
    }

}

public typealias DefaultItemSpacingCalculator = ItemSpacingCalculator
    & ChartModeProvider
    & SectionSpacingCalculator
