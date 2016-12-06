public typealias ViewSizeProvider = Any
    & ViewWidthProvider
    & ViewHeightProvider

public protocol ViewHeightProvider {
    var visibleContentHeight: Float { get }
}

public protocol ViewWidthProvider {
    var viewWidth: Float { get }
}
