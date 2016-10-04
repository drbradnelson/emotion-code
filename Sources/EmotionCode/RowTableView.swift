import UIKit

class RowTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

	private let cellReuseIdentifier = "ItemCell"
	private let cellMargin: CGFloat = 10
	var isChartOverview = true

	var row: Chart.Row!

	override func awakeFromNib() {
		super.awakeFromNib()

		delegate = self
		dataSource = self
	}

	// MARK: Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return row?.items.count ?? 0
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

	func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		view.tintColor = .white
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return cellMargin
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard isChartOverview else { return UITableViewAutomaticDimension }

		// Set row height based on footer height and table view frame to fit in
		let itemsCount = CGFloat(row.items.count)
		let spacing = cellMargin * itemsCount

		return (frame.height - spacing) / itemsCount
	}

}
