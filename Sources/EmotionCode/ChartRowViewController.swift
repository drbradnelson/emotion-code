import UIKit

final class ChartRowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet private var tableView: UITableView!
	@IBOutlet private var indexPathLabel: UILabel!

	private let cellReuseIdentifier = "ItemCell"
	private let alphabet = Array(" ABCDEFG".characters)

	var row: Chart.Row!
	var indexPath: IndexPath!

	override func viewDidLoad() {
		super.viewDidLoad()
		indexPathLabel.text = "Column \(alphabet[indexPath.row]) – Row \(indexPath.section)"
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	// MARK: Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return row?.items.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ItemTableViewCell
		cell.titleLabel.text = row.items[indexPath.section].title
		return cell
	}

	// MARK: Table view delegate

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}

	// MARK: Segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? ChartItemViewController,
			let indexPath = tableView.indexPathForSelectedRow else { return }
		destination.item = row.items[indexPath.section]
	}
}
