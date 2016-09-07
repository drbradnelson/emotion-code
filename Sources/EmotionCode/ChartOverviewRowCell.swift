import UIKit

// MARK: Main

final class ChartOverviewRowCell: UICollectionViewCell {

    var itemViews: [ChartOverviewItemView]?

    private var itemBackgroundColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

}

// MARK: Setup

private extension ChartOverviewRowCell {

    func setup() {}

}

// MARK: Updating items

extension ChartOverviewRowCell {

    func update(withItems items: [ChartItem]) {
        itemViews?.forEach({ (view) in
            view.removeFromSuperview()
        })

        itemViews = [ChartOverviewItemView]()


        let contentView = self.contentView

        for item in items {

            var itemView = ChartOverviewItemView(frame: CGRect.zero)
            itemView.title = item.title
            itemView.backgroundColor = itemBackgroundColor

            contentView.addSubview(itemView)
            itemViews?.append(itemView)
        }

        setNeedsLayout()
    }

    func update(itemBackgroundColor color: UIColor) {
        itemBackgroundColor = color
        itemViews?.forEach({ (view) in
            view.backgroundColor = color
        })
    }

}

// MARK: Layouting

extension ChartOverviewRowCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        ChartOverviewRowCellLayout.layout(itemViews: itemViews!, inContainer: self)
    }

}
