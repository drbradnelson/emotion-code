import UIKit

class RowTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

	private let cellReuseIdentifier = "ItemCell"

	var row: Chart.Row!

	override func awakeFromNib() {
		super.awakeFromNib()

		delegate = self
		dataSource = self

		estimatedRowHeight = 44
		rowHeight = UITableViewAutomaticDimension
	}

	// MARK: Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return row.items.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ItemTableViewCell
		cell.titleLabel.text = row.items[indexPath.section].title
		return cell
	}

	// MARK: Table view delegate

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}

}
