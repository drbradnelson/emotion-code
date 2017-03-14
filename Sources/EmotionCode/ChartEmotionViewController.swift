import UIKit

final class ChartEmotionViewController: UICollectionViewController {

    private var emotionDescription: String!

    private var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    func set(_ emotion: Chart.Emotion) {
        navigationItem.title = emotion.title
        emotionDescription = emotion.description
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        itemCell.addEmotionDescriptionView(withDescription: emotionDescription)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        setDescriptionVisibleAlongsideTransition(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDescriptionVisibleAlongsideTransition(false)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    // MARK: Layout

    private func setDescriptionVisibleAlongsideTransition(_ descriptionVisible: Bool) {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.setEmotionDescriptionVisible(descriptionVisible)
        }, completion: { [itemCell] context in
            guard !context.isCancelled, !descriptionVisible else { return }
            itemCell.removeEmotionDescriptionView()
        })
    }

    private func layoutCellsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { $0.layoutIfNeeded() }
        }, completion: { [chartLayout] context in
            guard !context.isCancelled else { return }
            chartLayout.store.dispatch(.viewDidTransition)
            chartLayout.invalidateLayout()
        })
    }

    // MARK: Cell

    private var itemCell: ItemCollectionViewCell {
        let indexPath = collectionView!.indexPathForSelectedItem!
        return collectionView!.cellForItem(at: indexPath) as! ItemCollectionViewCell
    }

}

extension ChartEmotionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutProgram.Mode {
        let selectedIndexPath = collectionView.indexPathForSelectedItem!
        return .emotion(selectedIndexPath, isFocused: false)
    }

}
