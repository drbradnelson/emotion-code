import UIKit

final class ChartColumnViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var column: Chart.Column!
    var selectedSection: Int!

    // MARK: Collection view delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard selectedSection == indexPath.section else {
            return CGSize.zero
        }

        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        let widthSpacing = layout.sectionInset.left + layout.sectionInset.right
        let width = collectionView.bounds.width - widthSpacing

        return CGSize(width: width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard selectedSection == section else {
            return UIEdgeInsets(top: 0.01, left: 0, bottom: 0.01, right: 0)
        }

        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        if UIDevice.current.orientation == .portrait {
            var inset = layout.sectionInset
            inset.top = 80
            return inset
        }

        return layout.sectionInset
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

        destination.item = column.items[indexPath.item]
    }

}
