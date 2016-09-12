import UIKit

// MARK: Main

class CollectionViewReusableViewWithTitle: UICollectionReusableView {

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

extension CollectionViewReusableViewWithTitle : ViewWithTitle {}

// MARK: Setup

private extension CollectionViewReusableViewWithTitle {

    func setup() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFontOfSize(20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
    }

}

// MARK: Layout calculation

extension CollectionViewReusableViewWithTitle {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }

}
