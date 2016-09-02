import UIKit

class CollectionViewReusableViewWithTitle: UICollectionReusableView {

    private (set) var titleLabel: UILabel
    override init(frame: CGRect) {
        self.titleLabel = UILabel.init()
        super.init(frame: frame)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.titleLabel = UILabel.init()
        super.init(coder: aDecoder)

        self.setup()
    }
}

// MARK: ViewWithTitle

extension CollectionViewReusableViewWithTitle : ViewWithTitle {}

// MARK: Setup

private extension CollectionViewReusableViewWithTitle {

    func setup() {

        self.addSubview(self.titleLabel)

        self.titleLabel.font = UIFont.systemFontOfSize(20)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .Center
    }
}

// MARK: Layout calculation

extension CollectionViewReusableViewWithTitle {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
}
