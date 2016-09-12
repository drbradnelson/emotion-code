import UIKit

// MARK: Main

struct ChartOverviewRowCellLayout {}

extension ChartOverviewRowCellLayout {

    static let desiredItemHeight: CGFloat = 20
    static let spacingBetweenItems: CGFloat = 5

    static func layout(itemViews itemViews: [ChartOverviewItemView], inContainer container: UIView) {
        let bounds = container.bounds

        let itemHeight = (bounds.height - spacingBetweenItems * CGFloat(itemViews.count - 1)) / CGFloat(itemViews.count)
        let itemWidth = bounds.width

        _ = itemViews.reduce(0.0, combine: { currentValue, itemView -> CGFloat in
            itemView.frame = CGRect(x: 0, y: currentValue, width: itemWidth, height: itemHeight)
            return currentValue + itemHeight + spacingBetweenItems
        })
    }

    static func height(forItems numberOfItems: Int) -> CGFloat {
        return desiredItemHeight * CGFloat(numberOfItems) + CGFloat(numberOfItems - 1) * spacingBetweenItems
    }

}
