import UIKit

class RowCell: UICollectionViewCell {

	@IBOutlet var tableView: RowTableView!

	var row: Chart.Row!

	override func awakeFromNib() {
		super.awakeFromNib()
		tableView.row = row
	}
}
