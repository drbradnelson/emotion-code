import UIKit
import ChartLayoutCalculator

final class ChartSectionViewController: UICollectionViewController {

    var section: Chart.Section!

    // MARK: Title

    func setTitle(forSection section: Int) {
        let column = (section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
        let row = section / ChartLayout.numberOfColumns + 1
        let columnName = String.alphabet[column]
        let localizedFormat = NSLocalizedString("Column %@ - Row %i", comment: "")
        navigationItem.title = String.localizedStringWithFormat(localizedFormat, columnName, row)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
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
        guard let item = collectionView?.indexPathForSelectedItem?.item else {
            preconditionFailure()
        }
        destination.setTitle(for: section.emotions[item])
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutMode {
        guard let selectedSection = collectionView.indexPathForSelectedItem?.section else {
            preconditionFailure()
        }
        return .section(selectedSection)
    }

}
