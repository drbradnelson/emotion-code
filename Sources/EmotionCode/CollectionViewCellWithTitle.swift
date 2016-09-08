import UIKit

// MARK: Main

final class CollectionViewCellWithTitle: UICollectionViewCell {

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

// MARK: ViewWithTitle

extension CollectionViewCellWithTitle : ViewWithTitle {}

// MARK: Setup

private extension CollectionViewCellWithTitle {

    func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFontOfSize(20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
    }

}

// MARK: Layout calculation

extension CollectionViewCellWithTitle {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds
    }

}
