import UIKit

class ChartColumnCollectionViewController: UICollectionViewController {

    var column: Chart.Column!

    // MARK: Collection view data source

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return column.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let title = column.items[indexPath.item].title
        cell.configure(title: title)
        return cell
    }

}
