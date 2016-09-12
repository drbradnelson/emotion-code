import UIKit

// MARK: Main

final class ChartReusableTitleView: UICollectionReusableView {

    private (set) var titleLabel: UILabel

    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}

// MARK: View with title

extension ChartReusableTitleView : ViewWithTitle {}

// MARK: Setup

private extension ChartReusableTitleView {

    func setup() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFontOfSize(20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
    }

}

// MARK: Layout calculation

extension ChartReusableTitleView {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }

}
