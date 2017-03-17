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
        showDescriptionAlongsideTransition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    // MARK: Layout

    private func showDescriptionAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell, collectionView, chartLayout] _ in
            itemCell.setEmotionDescriptionVisible(true)
            let indexPath = collectionView!.indexPath(for: itemCell)!
            let size = chartLayout.store.view.items[indexPath]!.frame.size
            itemCell.setEmotionDescriptionSize(to: size.cgSize)
        }, completion: nil)
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
