import UIKit

final class ChartViewController: UICollectionViewController {

    private let chartColumns = ChartController().chart.columns

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chartColumns.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartColumns[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.preferredReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let item = chartColumns[indexPath.section].items[indexPath.item]
        cell.configure(item: item)
        return cell
    }

    // MARK: Storyboard segue

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return collectionView?.collectionViewLayout is ChartLayout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartColumnViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartColumnViewController) {
        guard let section = collectionView?.indexPathForSelectedItem?.section else {
            preconditionFailure()
        }
        destination.setTitle(forSection: section)
        destination.column = chartColumns[section]
    }

}
