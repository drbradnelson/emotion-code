import UIKit

final class ChartCollectionViewController: UICollectionViewController {

    private let chart = ChartController().chart

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chart.rows.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chart.rows[section].columns.reduce(0) { itemsCount, column in
            itemsCount + column.items.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        
        let columnIndex = (indexPath.item + 2) % 2
        let itemIndex = (indexPath.item - columnIndex) / 2
        
        let title = chart.rows[indexPath.section].columns[columnIndex].items[itemIndex].title
        cell.configure(title: title)
        return cell
    }

}
