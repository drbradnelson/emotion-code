import UIKit

final class ChartRowViewController: UIViewController {

	@IBOutlet private var tableView: RowTableView!
	@IBOutlet private var indexPathLabel: UILabel!

	private let cellReuseIdentifier = "ItemCell"
	private let alphabet = Array(" ABCDEFG".characters)

	var indexPath: IndexPath!
	var row: Chart.Row!

	override func viewDidLoad() {
		super.viewDidLoad()
		indexPathLabel.text = "Column \(alphabet[indexPath.row]) – Row \(indexPath.section)"
		tableView.row = row
	}

	// MARK: Storyboard segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? ChartItemViewController,
			let indexPath = tableView.indexPathForSelectedRow else { return }
		destination.item = row.items[indexPath.section]
	}
}
