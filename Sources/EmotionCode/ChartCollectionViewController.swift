import UIKit

class ChartCollectionViewController: UICollectionViewController {

	private let cellReuseIdentifier = "ItemCell"
	private let chart = ChartController().chart

	// MARK: Collection view data source

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return chart.columns.reduce(0) { maxRowCount, column in
			max(maxRowCount, column.rows.count)
		}
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return chart.columns.count
	}
}
