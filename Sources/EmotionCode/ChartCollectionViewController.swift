import UIKit

final class ChartCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

	private let cellReuseIdentifier = "RowCell"
	private let headerReuseIdentifier = "HeaderCell"
	private let chart = ChartController().chart
	private let alphabet = Array(" ABCDEFG".characters)

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.delegate = self
		collectionView?.register(HeaderCell.self, forCellWithReuseIdentifier: headerReuseIdentifier)
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
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderCell
			cell.titleLabel.text = "\(alphabet[indexPath.row])"
			return cell
		} else if indexPath.row == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderCell
			cell.titleLabel.text = "\(indexPath.section)"
			return cell
		}

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RowCell
		cell.row = row(at: indexPath)
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
		super.prepare(for: segue, sender: sender)

		guard let destination = segue.destination as? ChartRowViewController,
			let indexPath = collectionView!.indexPathsForSelectedItems?.first else { return }
		destination.row = chart.columns[indexPath.row - 1].rows[indexPath.section - 1]
		destination.indexPath = indexPath
	}

	// MARK: Collection view delegate flow layout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsCount = CGFloat(chart.columns.count)
		let columnsCount = CGFloat(chart.columns.count * 4 + 1)

		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (itemsCount)
		let totalSize = collectionView.bounds.width - spacing
		let size = totalSize / columnsCount

		let height = (indexPath.section == 0) ? size: size * 4
		let width = (indexPath.row == 0) ? size: size * 4

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
