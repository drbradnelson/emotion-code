import UIKit

final class RowCollectionViewCell: UICollectionViewCell {

	@IBOutlet var tableView: RowTableView!

	override func prepareForReuse() {
		super.prepareForReuse()
		tableView.dataSource = tableView
		tableView.reloadData()
	}

}
