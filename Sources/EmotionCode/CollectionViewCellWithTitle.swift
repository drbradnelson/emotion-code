import Foundation
import UIKit

class CollectionViewCellWithTitle: UICollectionViewCell {

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

extension CollectionViewCellWithTitle : ViewWithTitle {}

// MARK: Setup

private extension CollectionViewCellWithTitle {

    func setup() {
        self.contentView.addSubview(self.titleLabel)

        self.titleLabel.font = UIFont.systemFontOfSize(20)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .Center
    }
}

// MARK: Layout calculation

extension CollectionViewCellWithTitle {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.bounds
    }
}
