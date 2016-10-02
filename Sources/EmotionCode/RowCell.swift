import UIKit

class RowCell: UICollectionViewCell {

	@IBOutlet private var stackView: UIStackView!

	var row: Chart.Row!

	override func prepareForReuse() {
		super.prepareForReuse()
		row = nil
		for view in stackView.arrangedSubviews {
			view.removeFromSuperview()
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		guard stackView.arrangedSubviews.isEmpty && row != nil else { return }

		for item in row.items {
			let titleView = TitleView()
			titleView.titleLabel.text = item.title
			stackView.addArrangedSubview(titleView)
		}
	}
}
