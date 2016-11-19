import UIKit

final class ChartHeaderView: UICollectionReusableView {

    static let columnKind = "ColumnKind"
    static let kindRowHeader = "RowKind"

    static let preferredReuseIdentifier = "ChartHeader"

    private let titleLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.contentMode = .center
        addSubview(titleLabel)
    }

    func configure(title: String) {
        titleLabel.text = title
    }

}
