protocol ChartLayoutCalculatorInterface: class {

    associatedtype Item
    associatedtype Header

    var chartSize: Size { get }
    var items: [IndexPath: Item] { get }
    var columnHeaders: [IndexPath: Header] { get }
    var rowHeaders: [IndexPath: Header] { get }
    var labelSizes: [IndexPath: Size] { get }

}

final class ChartLayoutCalculator: ChartLayoutCalculatorInterface {

    enum Mode {
        case all
        case section(Int, isFocused: Bool)
        case emotion(IndexPath, isFocused: Bool)
    }

    struct Item {
        let frame: Rect
        let alpha: Float
    }
    typealias Header = Item

    private struct Parameters {
        static let minViewHeightForCompactLayout = 554
        static let headerSize = Size(width: 30, height: 30)
        static let itemHeight = 18
        static let itemPadding = 8
        static let contentPadding = 10
        static let sectionSpacing = Size(width: 5, height: 5)
        static let itemSpacing = 10
    }

    var chartSize: Size = .zero
    var items: [IndexPath: Item] = [:]
    var columnHeaders: [IndexPath: Header] = [:]
    var rowHeaders: [IndexPath: Header] = [:]
    var labelSizes: [IndexPath: Size] = [:]

    private var mode: Mode
    private let numberOfColumns: Int
    private let itemsPerSection: [Int]

    private var viewSize: Size
    private let topContentInset: Int
    private let bottomContentInset: Int

    init(mode: Mode, numberOfColumns: Int, itemsPerSection: [Int], viewSize: Size, topContentInset: Int, bottomContentInset: Int) {
        self.mode = mode
        self.numberOfColumns = numberOfColumns
        self.itemsPerSection = itemsPerSection
        self.viewSize = viewSize
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
    }

}
