import UIKit

final class ChartColumnViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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

    // MARK: Collection view delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemsCount = CGFloat(column.items.count)

        let widthSpacing = layout.sectionInset.left + layout.sectionInset.right
        let width = (collectionView.bounds.width - widthSpacing)

        var height: CGFloat = 60

        if collectionView.bounds.width > collectionView.bounds.height {
            let heightSpacing = layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing * (itemsCount - 1)
            height = (collectionView.bounds.height - heightSpacing) / (itemsCount + 2)
        }

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.bounds.width > collectionView.bounds.height {
            return UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
        return UIEdgeInsets(top: 100, left: 30, bottom: 100, right: 30)
    }

    // MARK: View controller delegate

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }

}
