protocol ChartLayoutItemsCalculatorInterface: class {

    associatedtype Mode
    associatedtype Item
    associatedtype DataSource

    var items: [IndexPath: Item] { get }
    var contentOffset: Point { get }

    init(dataSource: DataSource)

}

final class ChartLayoutItemsCalculator: ChartLayoutItemsCalculatorInterface {

    typealias Mode = ChartLayoutCore.Mode
    typealias Item = ChartLayoutCore.Item

    struct DataSource {
        let mode: Mode
        let itemsPerSection: [Int]
        let numberOfColumns: Int
        let visibleViewSize: Int
        let initialPosition: Point
        let columnWidth: Int
        let rowHeight: Int
        let itemSpacing: Int
        let sectionSpacing: Size
    }

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    var items: [IndexPath: Item] {
        var items: [IndexPath: Item] = [:]
        for (section, itemsCount) in dataSource.itemsPerSection.enumerated() {
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let frame = frameForItem(at: indexPath)
                let alpha = alphaForItem(at: indexPath)
                items[indexPath] = Item(frame: frame, alpha: alpha)
            }
        }
        return items
    }

    var contentOffset: Point = .zero

    private let dataSource: DataSource

    private func alphaForItem(at indexPath: IndexPath) -> Float {
        let isVisible: Bool
        switch dataSource.mode {
        case .all:
            isVisible = true
        case .section(let section, let isFocused):
            isVisible = !isFocused || indexPath.section == section
        case .emotion(let emotionIndexPath, let isFocused):
            isVisible = !isFocused || emotionIndexPath == indexPath
        }
        return isVisible ? 1 : 0
    }

    private func sizeForItem(at indexPath: IndexPath) -> Size {
        return Size(width: dataSource.columnWidth, height: 0)
    }

    private func frameForItem(at indexPath: IndexPath) -> Rect {
        let size = sizeForItem(at: indexPath)
        return Rect(origin: .zero, size: size)
    }

}

private extension Rect {
    static let zero = Rect(origin: .zero, size: .zero)
}
