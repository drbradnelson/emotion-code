import UIKit

final class ChartRowViewController: UIViewController {

	@IBOutlet private var tableView: RowTableView! {
		didSet {
			tableView?.isChartOverview = false
			tableView?.row = row
		}
	}

	@IBOutlet private var indexPathLabel: UILabel! {
		didSet {
			indexPathLabel?.text = "Column \(alphabet[indexPath.row]) – Row \(indexPath.section)"
		}
	}

	private let cellReuseIdentifier = "ItemCell"
	private let alphabet = Array(" ABCDEFG".characters)

	var indexPath: IndexPath!
	var row: Chart.Row!

	// MARK: Storyboard segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? ChartItemViewController,
			let indexPath = tableView.indexPathForSelectedRow else { return }
		destination.item = tableView.row.items[indexPath.section]
	}

}
