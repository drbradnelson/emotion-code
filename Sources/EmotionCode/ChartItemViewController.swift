import UIKit

class ChartItemViewController: UIViewController {

	@IBOutlet private var itemView: UIView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var descriptionTextView: UITextView!

	var item: Chart.Item!

	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = item.title
		descriptionTextView.text = item.description
	}
}
