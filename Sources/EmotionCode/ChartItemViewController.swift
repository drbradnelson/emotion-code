import UIKit

final class ChartItemViewController: UICollectionViewController {

    var item: Chart.Item!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = collectionView?.indexPathsForSelectedItems?.first,
            let cell = collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        cell.configure(title: item.description)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let indexPath = collectionView?.indexPathsForSelectedItems?.first,
            let cell = collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        cell.configure(title: item.title)
    }

}
