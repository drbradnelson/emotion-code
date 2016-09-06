import UIKit

final class ChartOverviewItemView: UIView {

    private (set) var titleLabel: UILabel

    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        titleLabel = UILabel()
        super.init(coder: aDecoder)

        setup()
    }
}

// MARK: View with title

extension ChartOverviewItemView : ViewWithTitle {}

// MARK: Setup

private extension ChartOverviewItemView {

    func setup() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .Center
    }
}

// MARK: Layout calculation

extension ChartOverviewItemView {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
}
