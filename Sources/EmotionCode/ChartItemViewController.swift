import UIKit

final class ChartItemViewController: UICollectionViewController {

    func setTitle(for emotion: Chart.Emotion) {
        navigationItem.title = emotion.title
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateDescriptionVisible(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateDescriptionVisible(false)
    }

    private func animateDescriptionVisible(_ descriptionVisible: Bool) {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.setDescriptionVisible(descriptionVisible)
            }, completion: nil)
    }

    // MARK: Cell

    private var itemCell: ItemCollectionViewCell {
        let indexPath = collectionView!.indexPathForSelectedItem!
        return collectionView?.cellForItem(at: indexPath) as! ItemCollectionViewCell
    }

}
