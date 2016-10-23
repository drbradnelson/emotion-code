import UIKit

final class ChartColumnViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var columns: [Chart.Column]!

    // MARK: Collection view delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemsCount: CGFloat = 5

        let widthSpacing = layout.sectionInset.left + layout.sectionInset.right
        let width = (collectionView.bounds.width - widthSpacing)

        if collectionView.bounds.width > collectionView.bounds.height {
            let heightSpacing = layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing * (itemsCount - 1)
            let height = (collectionView.bounds.height - heightSpacing) / (itemsCount + 2)
            return CGSize(width: width, height: height)
        }

        return CGSize(width: width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.bounds.width > collectionView.bounds.height {
            return UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
        return UIEdgeInsets(top: 100, left: 30, bottom: 100, right: 30)
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItem", sender: self)
    }

    // MARK: View controller delegate

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChartItemViewController,
            let indexPath = collectionView?.indexPathsForSelectedItems?.first else { return }

        destination.item = columns[indexPath.section].items[indexPath.item]
    }

}
