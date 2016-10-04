import UIKit

final class ChartCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

	private let cellReuseIdentifier = "RowCell"
	private let headerReuseIdentifier = "HeaderCell"

	private let chart = ChartController().chart
	private let alphabet = Array(" ABCDEFG".characters)

	private var cellHeight: CGFloat!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.delegate = self
		collectionView?.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: headerReuseIdentifier)
	}

	// MARK: Collection view data source

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sections = chart.columns.reduce(0) { maxRowCount, column in
			max(maxRowCount, column.rows.count)
		}
		return sections + 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return chart.columns.count + 1
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.section == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
			cell.titleLabel.text = "\(alphabet[indexPath.row])"
			return cell
		} else if indexPath.row == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
			cell.titleLabel.text = "\(indexPath.section)"
			return cell
		}

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RowCollectionViewCell
		cell.tableView.row = row(at: indexPath)
		return cell
	}

	// MARK: Get row at index path

	private func row(at indexPath: IndexPath) -> Chart.Row? {
		let row = indexPath.section - 1
		let column = indexPath.item - 1
		let columns = chart.columns

		guard columns.indices.contains(column) && columns[column].rows.indices.contains(row) else { return nil }

		return chart.columns[column].rows[row]
	}

	// MARK: Segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let destination = segue.destination as? ChartRowViewController,
			let indexPath = collectionView!.indexPathsForSelectedItems?.first else { return }
		destination.row = chart.columns[indexPath.row - 1].rows[indexPath.section - 1]
		destination.indexPath = indexPath
	}

	// MARK: Collection view delegate flow layout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let columnsCount = CGFloat(chart.columns.count)

		// Set size depending on spacing between cells and header width
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (columnsCount)
		let headerSize = CGFloat(30)
		let totalSize = collectionView.bounds.width - spacing - headerSize
		let cellSize = totalSize / columnsCount

		let width = (indexPath.row == 0) ? headerSize: cellSize
		let height = (indexPath.section == 0) ? headerSize: cellSize

		return CGSize(width: width, height: height)
	}

	// MARK: View controller delegate

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionViewLayout.invalidateLayout()
	}

	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return ChartAnimator(operation: operation)
	}
}
