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
        let visibleViewSize: Size
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

    private func itemHeight(at indexPath: IndexPath) -> Int {
        switch dataSource.mode {
        case .all:
            let maxNumberOfItemsInSection = dataSource.itemsPerSection.max()!
            let totalItemSpacing = dataSource.itemSpacing * (maxNumberOfItemsInSection - 1)
            return Int(round(Double(dataSource.rowHeight - totalItemSpacing) / Double(maxNumberOfItemsInSection)))
        case .section, .emotion:
            let numberOfItems = dataSource.itemsPerSection[indexPath.section]
            let totalItemSpacing = dataSource.itemSpacing * (numberOfItems - 1)
            return Int(round(Double(dataSource.rowHeight - totalItemSpacing) / Double(numberOfItems)))
        }
    }

    private func sizeForItem(at indexPath: IndexPath) -> Size {
        let height = itemHeight(at: indexPath)
        return Size(width: dataSource.columnWidth, height: height)
    }

    private func xPositionForItem(at indexPath: IndexPath) -> Int {
        let column = indexPath.section % dataSource.numberOfColumns
        return dataSource.initialPosition.x + column * (dataSource.columnWidth + dataSource.sectionSpacing.width)
    }

    private func positionForItem(at indexPath: IndexPath) -> Point {
        let x = xPositionForItem(at: indexPath)
        let y = 0
        return Point(x: x, y: y)
    }

    private func frameForItem(at indexPath: IndexPath) -> Rect {
        let position = positionForItem(at: indexPath)
        let size = sizeForItem(at: indexPath)
        return Rect(origin: position, size: size)
    }

}

private extension Rect {
    static let zero = Rect(origin: .zero, size: .zero)
}
