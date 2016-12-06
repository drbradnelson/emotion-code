public protocol ItemSpacing {

    var itemSpacing: Float { get }

}

public extension ItemSpacing where Self: DefaultItemSpacing {

    var itemSpacing: Float {
        switch mode {
        case .all: return 5
        case .section: return 10
        case .emotion: return verticalSectionSpacing
        }
    }

}

public typealias DefaultItemSpacing = ItemSpacing
    & ChartMode
    & SectionSpacing
