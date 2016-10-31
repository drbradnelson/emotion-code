import UIKit

final class ChartColumnViewController: UICollectionViewController {

    var column: Chart.Column!
    var selectedSection: Int!

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItem", sender: self)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChartItemViewController,
            let item = collectionView?.indexPathsForSelectedItems?.first?.item else { return }

        destination.useLayoutToLayoutNavigationTransitions = true
        destination.item = column.items[item]
    }

}
