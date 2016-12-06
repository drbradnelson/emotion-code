public typealias ViewSize = Any
    & ViewWidth
    & ViewHeight

public protocol ViewHeight {
    var visibleContentHeight: Float { get }
}

public protocol ViewWidth {
    var viewWidth: Float { get }
}
