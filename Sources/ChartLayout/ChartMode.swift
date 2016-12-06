public enum ChartLayoutMode {
    case all
    case section(Int)
    case emotion(IndexPath)
}

public protocol ChartMode {

    var mode: ChartLayoutMode { get }

}
