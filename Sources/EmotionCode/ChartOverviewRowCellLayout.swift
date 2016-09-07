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

        var verticalOffset: CGFloat = 0

        for view in itemViews {
            view.frame = CGRect(x: 0, y: verticalOffset, width: itemWidth, height: itemHeight)
            verticalOffset += itemHeight + spacingBetweenItems
        }
    }

    static func height(forItems numberOfItems: Int) -> CGFloat {
        return desiredItemHeight * CGFloat(numberOfItems) + CGFloat(numberOfItems - 1) * spacingBetweenItems
    }

}
