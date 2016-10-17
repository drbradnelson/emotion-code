import UIKit

final class ChartCollectionViewController: UICollectionViewController {

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let title = columns[indexPath.section].items[indexPath.item].title
        cell.configure(title: title)
        return cell
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChartColumnCollectionViewController,
            let indexPath = collectionView?.indexPathsForSelectedItems?.first else { return }

        destination.column = columns[indexPath.section]
    }

}
