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
        let localizedFormat = NSLocalizedString("Column %@ - Row %i", comment: "")
        navigationItem.title = String.localizedStringWithFormat(localizedFormat, columnName, row)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        toggleLabelsAlongsideTransition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartLayout.store.dispatch(.viewWillTransition)
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEmotion", sender: self)
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

    // MARK: Layout

    private func toggleLabelsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.smallTitleLabel.alpha = 0
                cell.largeTitleLabel.alpha = 1
            }
        }, completion: { [chartLayout] context in
            guard !context.isCancelled else { return }
            chartLayout.store.dispatch(.viewDidTransition)
            chartLayout.invalidateLayout()
        })
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutProgram.Mode {
        let selectedSection = collectionView.indexPathForSelectedItem!.section
        return .section(selectedSection, isFocused: false)
    }

}
