//
//  ChartOverviewRowCell.swift
//  EmotionCode
//
//  Created by Andre Lami on 31/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

class ChartOverviewRowCell: UICollectionViewCell {

    var itemViews: [ChartOverviewItemView]?

    private var itemBackgroundColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setup()
    }
}

// MARK: Setup

private extension ChartOverviewRowCell {
    func setup() {}
}

// MARK: Updating items

extension ChartOverviewRowCell {

    func update(withItems items: [ChartItem]) {
        self.itemViews?.forEach({ (view) in
            view.removeFromSuperview()
        })

        self.itemViews = [ChartOverviewItemView]()


        let contentView = self.contentView

        for item in items {

            var itemView = ChartOverviewItemView.init(frame: CGRect.zero)
            itemView.title = item.title
            itemView.backgroundColor = self.itemBackgroundColor

            contentView.addSubview(itemView)
            self.itemViews?.append(itemView)
        }

        self.setNeedsLayout()
    }

    func update(itemBackgroundColor color: UIColor) {
        self.itemBackgroundColor = color
        self.itemViews?.forEach({ (view) in
            view.backgroundColor = color
        })
    }
}

// MARK: Layouting

extension ChartOverviewRowCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        ChartOverviewRowCellLayout.layout(itemViews: self.itemViews!, inContainer: self)
    }
}
