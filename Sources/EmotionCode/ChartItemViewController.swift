import UIKit

final class ChartItemViewController: UIViewController {

	@IBOutlet private var itemView: UIView!

	@IBOutlet private var titleLabel: UILabel! {
		didSet {
			titleLabel?.text = item.title
		}
	}

	@IBOutlet private var descriptionTextView: UITextView! {
		didSet {
			descriptionTextView?.text = item.description
		}
	}

	var item: Chart.Item!

}
