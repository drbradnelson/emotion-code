public enum ChartLayoutMode {
    case all
    case section(Int)
    case emotion(IndexPath)
}

public protocol ChartModeProvider {

    var mode: ChartLayoutMode { get }

}
