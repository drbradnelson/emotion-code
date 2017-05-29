protocol ChartLayoutItemsCalculatorInterface: class {

    var items: [IndexPath: ChartLayoutCore.Item] { get }

    init(mode: ChartLayoutCore.Mode, itemsPerSection: [Int], numberOfColumns: Int, columnWidth: Int, rowHeight: Int, initialPosition: Point, itemSpacing: Int, sectionSpacing: Size)

}

final class ChartLayoutItemsCalculator: ChartLayoutItemsCalculatorInterface {

    typealias Mode = ChartLayoutCore.Mode
    typealias Item = ChartLayoutCore.Item

    private let mode: Mode
    private let itemsPerSection: [Int]
    private let numberOfColumns: Int
    private let columnWidth: Int
    private let rowHeight: Int
    private let initialPosition: Point
    private let itemSpacing: Int
    private let sectionSpacing: Size

    init(mode: Mode, itemsPerSection: [Int], numberOfColumns: Int, columnWidth: Int, rowHeight: Int, initialPosition: Point, itemSpacing: Int, sectionSpacing: Size) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.columnWidth = columnWidth
        self.rowHeight = rowHeight
        self.initialPosition = initialPosition
        self.itemSpacing = itemSpacing
        self.sectionSpacing = sectionSpacing
    }

    private(set) lazy var items: [IndexPath: Item] = {
        var items: [IndexPath: Item] = [:]
        for (section, itemsCount) in self.itemsPerSection.enumerated() {
            for itemIndex in 0..<itemsCount {
                let indexPath = IndexPath(item: itemIndex, section: section)
                let item = self.item(at: indexPath)
                items[indexPath] = item
            }
        }
        return items
    }()

    private func alphaForItem(at indexPath: IndexPath) -> Float {
        let isVisible: Bool
        switch mode {
        case .all:
            isVisible = true
        case .section(let section, let isFocused):
            isVisible = !isFocused || indexPath.section == section
        case .emotion(let emotionIndexPath, let isFocused):
            isVisible = !isFocused || emotionIndexPath == indexPath
        }
        return isVisible ? 1 : 0
    }

    private func heightForItem(at indexPath: IndexPath) -> Int {
        switch mode {
        case .all:
            let maxNumberOfItemsInSection = itemsPerSection.max()!
            let totalItemSpacing = itemSpacing * (maxNumberOfItemsInSection - 1)
            return Int(round(Double(rowHeight - totalItemSpacing) / Double(maxNumberOfItemsInSection)))
        case .section, .emotion:
            let numberOfItems = itemsPerSection[indexPath.section]
            let totalItemSpacing = itemSpacing * (numberOfItems - 1)
            return Int(round(Double(rowHeight - totalItemSpacing) / Double(numberOfItems)))
        }
    }

    private func sizeForItem(at indexPath: IndexPath) -> Size {
        let height = heightForItem(at: indexPath)
        return Size(width: columnWidth, height: height)
    }

    private func xPositionForItem(at indexPath: IndexPath) -> Int {
        let column = indexPath.section % numberOfColumns
        return initialPosition.x + column * (columnWidth + sectionSpacing.width)
    }

    private func yPositionForSection(_ section: Int) -> Int {
        let row = section / numberOfColumns
        return initialPosition.y + row * (rowHeight + sectionSpacing.height)
    }

    private func yPositionForItem(at indexPath: IndexPath) -> Int {
        let sectionY = yPositionForSection(indexPath.section)
        let itemHeight = heightForItem(at: indexPath)
        let itemY = indexPath.item * (itemHeight + itemSpacing)
        return sectionY + itemY
    }

    private func positionForItem(at indexPath: IndexPath) -> Point {
        let x = xPositionForItem(at: indexPath)
        let y = yPositionForItem(at: indexPath)
        return Point(x: x, y: y)
    }

    private func frameForItem(at indexPath: IndexPath) -> Rect {
        let position = positionForItem(at: indexPath)
        let size = sizeForItem(at: indexPath)
        return Rect(origin: position, size: size)
    }

    private func item(at indexPath: IndexPath) -> Item {
        let frame = frameForItem(at: indexPath)
        let alpha = alphaForItem(at: indexPath)
        return Item(frame: frame, alpha: alpha)
    }

}
