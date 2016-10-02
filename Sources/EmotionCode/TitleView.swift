import UIKit

class TitleView: UIView {

	let titleLabel = UILabel()

	override func layoutSubviews() {
		super.layoutSubviews()
		titleLabel.font = .preferredFont(forTextStyle: .caption1)
		titleLabel.frame = bounds
		titleLabel.textAlignment = .center
		addSubview(titleLabel)

		backgroundColor = .lightGray
	}

}
