import UIKit

final class ChartColumnViewController: UICollectionViewController {

    var group: Chart.Group!

    // MARK: Title

    func setTitle(forSection section: Int) {
        let column = (section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
        let row = section / ChartLayout.numberOfColumns + 1
        let columnName = ["A", "B"][column] // Temporary
        let localizedFormat = NSLocalizedString("Row %i - Column %@", comment: "")
        navigationItem.title = String.localizedStringWithFormat(localizedFormat, row, columnName)
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItem", sender: self)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartItemViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartItemViewController) {
        guard let item = collectionView?.indexPathForSelectedItem?.item else {
            preconditionFailure()
        }
        destination.setTitle(for: group.emotions[item])
    }

}
