import UIKit

final class HeaderCollectionViewCell: UICollectionViewCell {

	private(set) var titleLabel: UILabel!

	override init(frame: CGRect) {
		super.init(frame: frame)
		isUserInteractionEnabled = false

		titleLabel = UILabel()
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.textAlignment = .center
		addSubview(titleLabel)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		titleLabel.frame = bounds
	}

}
