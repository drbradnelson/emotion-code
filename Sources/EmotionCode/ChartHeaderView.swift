import UIKit

final class ChartHeaderView: UICollectionReusableView {

    static let kindColumnHeader = "ColumnKind"
    static let kindRowHeader = "RowKind"

    private let titleLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .footnote)
        addSubview(titleLabel)
    }

    func configure(title: String) {
        titleLabel.text = title
    }

}
