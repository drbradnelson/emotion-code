import UIKit

final class ChartCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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

    // MARK: Collection view delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2

        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * (numberOfColumns - 1)
        let width = (collectionView.bounds.width - spacing) / numberOfColumns

        return CGSize(width: width, height: 30)
    }

}
