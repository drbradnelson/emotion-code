import UIKit

final class ChartEmotionViewController: UICollectionViewController {

    var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    func setTitle(for emotion: Chart.Emotion) {
        navigationItem.title = emotion.title
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDescriptionVisibleAlongsideTransition(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartLayout.program.dispatch(.viewDidTransition)
        chartLayout.invalidateLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDescriptionVisibleAlongsideTransition(false)
        chartLayout.program.dispatch(.viewWillTransition)
    }

    private func setDescriptionVisibleAlongsideTransition(_ descriptionVisible: Bool) {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.largeTitleLabel.alpha = 0
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
        let selectedIndexPath = collectionView.indexPathForSelectedItem!
        return .emotion(selectedIndexPath, isFocused: false)
    }

}
