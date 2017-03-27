import UIKit
import Elm

final class ChartViewController: UICollectionViewController {

    private var store: Store<ChartLayoutProgram>!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        let sectionsRange = 0..<collectionView!.numberOfSections
        let itemsPerSection = sectionsRange.map(collectionView!.numberOfItems)
        store = ChartLayoutProgram.makeStore(
            delegate: self,
            seed: .init(
                mode: .all,
                itemsPerSection: itemsPerSection,
                numberOfColumns: ChartLayout.numberOfColumns,
                topContentInset: .init(collectionView!.contentInset.top),
                bottomContentInset: .init(collectionView!.contentInset.bottom),
                viewSize: .init(cgSize: collectionView!.bounds.size)
            )
        )
        let chartLayout = collectionViewLayout as! ChartLayout
        chartLayout.set(store)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.columnKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.rowKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutContentAlongsideTransition(with: transitionCoordinator)
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            for cell in collectionView!.visibleCells {
                let cell = cell as! ItemCollectionViewCell
                cell.setEmotionDescriptionVisible(false)
            }
        }, completion: { [collectionView] context in
            guard !context.isCancelled else { return }
            for cell in collectionView!.visibleCells {
                let cell = cell as! ItemCollectionViewCell
                cell.removeEmotionDescriptionView()
            }
        })
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        layout(cell, with: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSection", sender: self)
    }

    // MARK: Layout

    private func layoutContentAlongsideTransition(with coordinator: UIViewControllerTransitionCoordinator?) {
        coordinator?.animate(alongsideTransition: { [collectionView, layout] _ in
            collectionView!.visibleCellsWithIndexPaths.forEach(layout)
            let kinds = [ChartHeaderView.columnKind, ChartHeaderView.rowKind]
            let supplementaryViews = kinds.flatMap(collectionView!.visibleSupplementaryViews)
            for view in supplementaryViews { view.layoutIfNeeded() }
        }, completion: nil)
    }

    private func layout(_ cell: UICollectionViewCell, with indexPath: IndexPath) {
        let cell = cell as! ItemCollectionViewCell
        let labelSize = store.view.labelSizes[indexPath]!
        cell.setTitleLabelSize(to: labelSize.cgSize)
        cell.shrinkTitleLabel()
        cell.layoutIfNeeded()
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
        store.dispatch(.systemDidSetViewSize(.init(cgSize: size)))
        layoutContentAlongsideTransition(with: coordinator)
    }

}

extension ChartViewController: StoreDelegate {

    func store(_ store: Store<ChartLayoutProgram>, didUpdate view: ChartLayoutProgram.View) {}
    func store(_ store: Store<ChartLayoutProgram>, didRequest action: ChartLayoutProgram.Action) {}

}
