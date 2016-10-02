import UIKit

class ChartCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

	private let cellReuseIdentifier = "RowCell"
	private let chart = ChartController().chart

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.delegate = self
	}

	// MARK: Collection view data source

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sections = chart.columns.reduce(0) { maxRowCount, column in
			max(maxRowCount, column.rows.count)
		}
		return sections
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return chart.columns.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! RowCell
		cell.row = row(at: indexPath)
		return cell
	}

	// MARK: Get row at index path

	private func row(at indexPath: IndexPath) -> Chart.Row? {
		let row = indexPath.section
		let column = indexPath.item
		let columns = chart.columns

		guard columns.indices.contains(column) && columns[column].rows.indices.contains(row) else { return nil }

		return chart.columns[column].rows[row]
	}

	// MARK: Segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		guard let destination = segue.destination as? ChartRowViewController,
			let indexPath = collectionView!.indexPathsForSelectedItems?.first else { return }
		destination.row = chart.columns[indexPath.row].rows[indexPath.section]
	}

	// MARK: Collection view delegate flow layout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let columnsCount = CGFloat(chart.columns.count)

		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (columnsCount - 1)
		let size = (collectionView.bounds.width - spacing) / columnsCount

		return CGSize(width: size, height: size)
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
