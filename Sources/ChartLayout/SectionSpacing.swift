public protocol SectionSpacing {

    var horizontalSectionSpacing: Float { get }
    var verticalSectionSpacing: Float { get }

}

public extension SectionSpacing where Self: DefaultSectionSpacing {

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

public typealias DefaultSectionSpacing = SectionSpacing
    & ChartMode
