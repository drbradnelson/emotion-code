import UIKit

final class ChartViewController: UICollectionViewController {

    private let columns = ChartController().chart.rows.reduce([]) { columns, row in
        columns + row.columns
    }

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return columns.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.preferredReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let item = columns[indexPath.section].items[indexPath.item]
        cell.configure(item: item)
        return cell
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChartColumnViewController,
            let section = collectionView?.indexPathsForSelectedItems?.first?.section else { return }

        destination.useLayoutToLayoutNavigationTransitions = true
        destination.column = columns[section]
        destination.selectedSection = section
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return collectionView?.collectionViewLayout is ChartLayout
    }

}