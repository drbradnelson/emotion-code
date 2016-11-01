import UIKit

final class ChartItemViewController: UICollectionViewController {

    var item: Chart.Item!

    private var itemCell: ItemCollectionViewCell? {
        guard let indexPath = collectionView?.indexPathsForSelectedItems?.first else { return nil }
        return collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemCell?.showDescription()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemCell?.showTitle()
    }

}
