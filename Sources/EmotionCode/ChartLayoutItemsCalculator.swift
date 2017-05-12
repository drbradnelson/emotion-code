protocol ChartLayoutItemsCalculatorInterface: class {

    associatedtype Mode
    associatedtype Item

    var items: [IndexPath: Item] { get }
    var contentOffset: Point { get }

}

final class ChartLayoutItemsCalculator: ChartLayoutItemsCalculatorInterface {

    typealias Mode = ChartLayoutCore.Mode
    typealias Item = ChartLayoutCore.Item

    private let mode: Mode
    private let itemsPerSection: [Int]

    init(mode: Mode, itemsPerSection: [Int]) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
    }

    var items: [IndexPath: Item] {
        var items: [IndexPath: Item] = [:]
        for (section, itemsCount) in itemsPerSection.enumerated() {
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let alpha = alphaForItem(at: indexPath)
                items[indexPath] = Item(frame: .zero, alpha: alpha)
            }
        }
        return items
    }

    var contentOffset: Point = .zero

    private func alphaForItem(at indexPath: IndexPath) -> Float {
        let isHidden: Bool
        switch mode {
        case .all:
            isHidden = false
        case .section(let section, let isFocused):
            isHidden = !isFocused || indexPath.section == section
        case .emotion(let emotionIndexPath, let isFocused):
            isHidden = !isFocused || emotionIndexPath == indexPath
        }
        return isHidden ? 0 : 1
    }

}

private extension Rect {
    static let zero = Rect(origin: .zero, size: .zero)
}
