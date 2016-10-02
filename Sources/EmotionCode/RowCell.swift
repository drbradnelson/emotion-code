import UIKit

class RowCell: UICollectionViewCell {

	@IBOutlet private var stackView: UIStackView!

	var row: Chart.Row!

	override func layoutSubviews() {
		super.layoutSubviews()

		for view in stackView.arrangedSubviews {
			view.removeFromSuperview()
		}

		for item in row.items {
			let titleView = TitleView()
			titleView.titleLabel.text = item.title
			stackView.addArrangedSubview(titleView)
		}
	}
}
