import UIKit

final class ChartSectionViewController: UICollectionViewController {

    private var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    // MARK: Title

    func setTitle(forSection section: Int) {
        let column = section % ChartLayout.numberOfColumns
        let row = section / ChartLayout.numberOfColumns + 1
        let columnName = String.alphabet[column]
        let localizedFormat = NSLocalizedString("Column %@ \u{2013} Row %i", comment: "")
        navigationItem.title = String.localizedStringWithFormat(localizedFormat, columnName, row)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutContentAlongsideTransition(with: transitionCoordinator)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        layout(cell, with: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEmotion", sender: self)
    }

    // MARK: Layout

    private func layoutContentAlongsideTransition(with coordinator: UIViewControllerTransitionCoordinator?) {
        coordinator?.animate(alongsideTransition: { [collectionView, layout] _ in
            collectionView!.visibleCellsWithIndexPaths.forEach(layout)
            let kinds = [ChartHeaderView.columnKind, ChartHeaderView.rowKind]
            let supplementaryViews = kinds.flatMap(collectionView!.visibleSupplementaryViews)
            for view in supplementaryViews { view.layoutIfNeeded() }
        }, completion: { [chartLayout] context in
            guard !context.isCancelled else { return }
            chartLayout.store.dispatch(.viewDidTransition)
            chartLayout.invalidateLayout()
        })
    }

    private func layout(_ cell: UICollectionViewCell, with indexPath: IndexPath) {
        let cell = cell as! ItemCollectionViewCell
        let labelSize = chartLayout.store.view.labelSizes[indexPath]!
        cell.setTitleLabelSize(to: labelSize.cgSize)
        cell.enlargeTitleLabel()
        cell.layoutIfNeeded()
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartEmotionViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartEmotionViewController) {
        let selectedIndexPath = collectionView!.indexPathForSelectedItem!
        let chartDataSource = collectionView!.dataSource as! ChartViewControllerDataSource
        let emotion = chartDataSource.chart.section(atIndex: selectedIndexPath.section).emotions[selectedIndexPath.item]
        destination.set(emotion)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chartLayout.store.dispatch(.systemDidSetViewSize(.init(cgSize: size)))
        layoutContentAlongsideTransition(with: coordinator)
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutProgram.Mode {
        let selectedSection = collectionView.indexPathForSelectedItem!.section
        return .section(selectedSection, isFocused: false)
    }

}
