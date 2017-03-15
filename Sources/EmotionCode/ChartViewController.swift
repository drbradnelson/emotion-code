import UIKit

final class ChartViewController: UICollectionViewController {

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let chartLayout = collectionViewLayout as! ChartLayout
        chartLayout.mode = chartLayoutMode(with: collectionView!)

        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.columnKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.rowKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: ChartHeaderView.rowKind, ChartHeaderView.columnKind)
        toggleLabelsAlongsideTransition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutSupplementaryViewsAlongsideTransition(withKinds: ChartHeaderView.rowKind, ChartHeaderView.columnKind)
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSection", sender: self)
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

    // MARK: Layout

    private func toggleLabelsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.smallTitleLabel.alpha = 1
                cell.largeTitleLabel.alpha = 0
            }
        }, completion: nil)
    }

}

extension ChartViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutProgram.Mode {
        return .all
    }

}
