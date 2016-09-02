import Foundation
import UIKit

struct ChartOverviewRowCellLayout {


}

extension ChartOverviewRowCellLayout {

    static let desiredItemHeight: CGFloat = 20
    static let spacingBetweenItems: CGFloat = 5

    static func layout(itemViews itemViews: [ChartOverviewItemView], inContainer container: UIView) {

        let bounds = container.bounds

        let spacing: CGFloat = self.spacingBetweenItems
        let itemHeight = (CGRectGetHeight(bounds) - spacing * CGFloat(itemViews.count - 1)) / CGFloat(itemViews.count)
        let itemWidth = CGRectGetWidth(bounds)

        var verticalOffset: CGFloat = 0

        for view in itemViews {
            view.frame = CGRect.init(x: 0, y: verticalOffset, width: itemWidth, height: itemHeight)
            verticalOffset += itemHeight + spacing
        }
    }

    static func height(forItems numberOfItems: Int) -> CGFloat {

        return self.desiredItemHeight * CGFloat(numberOfItems) + CGFloat(numberOfItems - 1) * self.spacingBetweenItems
    }
}
