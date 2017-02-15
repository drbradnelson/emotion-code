import UIKit

final class ChartSectionViewController: UICollectionViewController {

    var chart: Chart!

    var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartLayout.program.dispatch(.systemDidSetIsFocused(true))
        chartLayout.invalidateLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
        chartLayout.program.dispatch(.systemDidSetIsFocused(false))
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
        let indexPath = collectionView!.indexPathForSelectedItem!
        let emotion = chart.section(atIndex: indexPath.section).emotions[indexPath.item]
        destination.setTitle(for: emotion)
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutModule.Mode {
        let selectedSection = collectionView.indexPathForSelectedItem!.section
        return .section(selectedSection)
    }

}
