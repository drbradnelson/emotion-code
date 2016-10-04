import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

	let titleLabel = UILabel()

	override func layoutSubviews() {
		super.layoutSubviews()
		isUserInteractionEnabled = false
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.frame = bounds
		titleLabel.textAlignment = .center
		addSubview(titleLabel)
	}

}
