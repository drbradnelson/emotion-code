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
        setDescriptionVisibleAlongsideTransition(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartLayout.store.dispatch(.viewDidTransition)
        chartLayout.invalidateLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDescriptionVisibleAlongsideTransition(false)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    private func setDescriptionVisibleAlongsideTransition(_ descriptionVisible: Bool) {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.largeTitleLabel.alpha = 0
            itemCell.setEmotionDescriptionVisible(descriptionVisible)
        }, completion: { [itemCell] _ in
            if !descriptionVisible {
                itemCell.removeEmotionDescriptionView()
            }
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
