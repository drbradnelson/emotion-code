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
        chartLayout.program.dispatch(.viewWillTransition)
    }

    private func setDescriptionVisibleAlongsideTransition(_ descriptionVisible: Bool) {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.setEmotionDescriptionVisible(descriptionVisible)
        }, completion: { [itemCell, chartLayout] context in
            guard !context.isCancelled else { return }
            if !descriptionVisible {
                itemCell.removeEmotionDescriptionView()
            } else {
                chartLayout.program.dispatch(.viewDidTransition)
                chartLayout.invalidateLayout()
            }
        })
    }

    // MARK: Cell

    private lazy var itemCell: ItemCollectionViewCell = {
        let indexPath = self.collectionView!.indexPathForSelectedItem!
        return self.collectionView!.cellForItem(at: indexPath) as! ItemCollectionViewCell
    }()

}

extension ChartEmotionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutModule.Mode {
        let selectedIndexPath = collectionView.indexPathForSelectedItem!
        return .emotion(selectedIndexPath, isFocused: false)
    }

}
