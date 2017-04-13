import UIKit

final class ChartViewController: UICollectionViewController {

    private var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        chartLayout.mode = chartLayoutMode(with: collectionView!)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.columnKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.rowKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition(with: transitionCoordinator)
        removeEmotionDescriptionsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.columnKind, ChartHeaderView.rowKind])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.columnKind, ChartHeaderView.rowKind])
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        layout(cell, with: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSection", sender: self)
    }

    // MARK: Layout

    private func layout(_ cell: UICollectionViewCell, with indexPath: IndexPath) {
        let cell = cell as! ItemCollectionViewCell
        let labelSize = chartLayout.core.view.labelSizes[indexPath]!
        cell.setTitleLabelSize(to: labelSize.cgSize)
        cell.shrinkTitleLabel()
        cell.layoutIfNeeded()
    }

    private func layoutCellsAlongsideTransition(with coordinator: UIViewControllerTransitionCoordinator?) {
        coordinator?.animate(alongsideTransition: { [collectionView, layout] _ in
            collectionView!.visibleCellsWithIndexPaths.forEach(layout)
        }, completion: nil)
    }

    private func removeEmotionDescriptionsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            for cell in collectionView!.visibleCells {
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setEmotionDescriptionVisible(false)
            }
        }, completion: { [collectionView] context in
            guard !context.isCancelled else { return }
            for cell in collectionView!.visibleCells {
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.removeEmotionDescriptionView()
            }
        })
    }

    private func layoutSupplementaryViewsAlongsideTransition(withKinds kinds: [String]) {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            let supplementaryViews = kinds.flatMap(collectionView!.visibleSupplementaryViews)
            supplementaryViews.forEach { $0.layoutIfNeeded() }
        }, completion: nil)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartSectionViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartSectionViewController) {
        let section = collectionView!.indexPathForSelectedItem!.section
        destination.setTitle(forSection: section)
    }

    @IBAction func unwindToChartViewController(with segue: UIStoryboardSegue) {}

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chartLayout.core.systemDidSet(viewSize: .init(cgSize: size))
        layoutCellsAlongsideTransition(with: coordinator)
    }

}

extension ChartViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutCore.Mode {
        return .all
    }

}
