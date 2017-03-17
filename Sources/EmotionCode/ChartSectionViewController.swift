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
        layoutContentAlongsideTransition()
        toggleLabelsAlongsideTransition()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartLayout.store.dispatch(.viewDidTransition)
        chartLayout.invalidateLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutContentAlongsideTransition()
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

    private func layoutContentAlongsideTransition() {
        transitionCoordinator?.animateAlongsideTransition { [collectionView] in
            collectionView?.layoutVisibleCells()
            collectionView?.layoutVisibleSupplementaryViews(ofKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
        }
    }

    private func toggleLabelsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.smallTitleLabel.alpha = 0
                cell.largeTitleLabel.alpha = 1
            }
            }, completion: nil)
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutProgram.Mode {
        let selectedSection = collectionView.indexPathForSelectedItem!.section
        return .section(selectedSection, isFocused: false)
    }

}

extension UICollectionView {

    func layoutVisibleCells() {
        for visibleCell in visibleCells {
            visibleCell.layoutIfNeeded()
        }
    }

    func layoutVisibleSupplementaryViews(ofKinds kinds: [String]) {
        for kind in kinds {
            let visibleSupplementaryView = visibleSupplementaryViews(ofKind: kind)
            for supplementaryView in visibleSupplementaryView {
                supplementaryView.layoutIfNeeded()
            }
        }
    }

}

extension UIViewControllerTransitionCoordinator {

    func animateAlongsideTransition(_ animations: @escaping () -> Void) {
        animate(alongsideTransition: { _ in animations() }, completion: nil)
    }

}
