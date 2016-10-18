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
        let spacing = layout.sectionInset.left + layout.sectionInset.right
        let width = (collectionView.bounds.width - spacing)

        return CGSize(width: width, height: 60)
    }

    // MARK: View controller delegate

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }

}
