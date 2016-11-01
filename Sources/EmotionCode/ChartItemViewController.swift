import UIKit

final class ChartItemViewController: UICollectionViewController {

    var item: Chart.Item!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggle()
    }

    private func toggle() {
        guard let indexPath = collectionView?.indexPathsForSelectedItems?.first,
            let cell = collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        cell.toggle()
    }

}
