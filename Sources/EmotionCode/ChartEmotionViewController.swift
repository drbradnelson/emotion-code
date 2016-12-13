import UIKit

final class ChartEmotionViewController: UICollectionViewController {

    func setTitle(for emotion: Chart.Emotion) {
        navigationItem.title = emotion.title
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDescriptionVisibleAlongsideTransition(true)
        layoutCellsAlongsideTransition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDescriptionVisibleAlongsideTransition(false)
        layoutCellsAlongsideTransition()
    }

    private func setDescriptionVisibleAlongsideTransition(_ descriptionVisible: Bool) {
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

extension ChartEmotionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutModule.Mode {
        guard let selectedIndexPath = collectionView.indexPathForSelectedItem else {
            preconditionFailure()
        }
        return .emotion(selectedIndexPath)
    }

}
