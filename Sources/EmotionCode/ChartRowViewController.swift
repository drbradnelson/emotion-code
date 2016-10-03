import UIKit

final class ChartRowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	@IBOutlet private var collectionView: UICollectionView!
	@IBOutlet private var indexPathLabel: UILabel!

	private let cellReuseIdentifier = "ItemCell"
	private let alphabet = Array(" ABCDEFG".characters)

	var row: Chart.Row!
	var indexPath: IndexPath!

	override func viewDidLoad() {
		super.viewDidLoad()
		indexPathLabel.text = "Column \(alphabet[indexPath.row]) – Row \(indexPath.section)"
	}

	// MARK: Collection view data source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return row?.items.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ItemCell
		cell.titleLabel.text = row.items[indexPath.row].title
		return cell
	}

	// MARK: Segue

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let destination = segue.destination as? ChartItemViewController,
			let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }

		destination.item = row.items[indexPath.row]
	}

	// MARK: Collection view delegate flow layout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsCount = CGFloat(row!.items.count)

		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let spacing = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom + flowLayout.minimumLineSpacing * (itemsCount - 1)
		let width = collectionView.bounds.width
		let height = (width - spacing) / itemsCount

		return CGSize(width: width, height: height)
	}

	// MARK: View controller delegate

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.collectionViewLayout.invalidateLayout()
	}
}
