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
        layoutContentAlongsideTransition(with: transitionCoordinator)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    // MARK: Layout

    private func layoutContentAlongsideTransition(with coordinator: UIViewControllerTransitionCoordinator?) {
        coordinator?.animate(alongsideTransition: { [collectionView, itemCell] _ in
            for cell in collectionView!.visibleCells { cell.layoutIfNeeded() }
            itemCell.setEmotionDescriptionVisible(true)
            itemCell.layoutEmotionDescriptionView()
        }, completion: { [chartLayout] context in
            guard !context.isCancelled else { return }
            chartLayout.store.dispatch(.viewDidTransition)
            chartLayout.invalidateLayout()
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chartLayout.store.dispatch(.systemDidSetViewSize(.init(cgSize: size)))
        layoutContentAlongsideTransition(with: coordinator)
    }

    // MARK: Cell

    private var itemCell: ItemCollectionViewCell {
        let indexPath = collectionView!.indexPathForSelectedItem!
        return collectionView!.cellForItem(at: indexPath) as! ItemCollectionViewCell
    }

}
