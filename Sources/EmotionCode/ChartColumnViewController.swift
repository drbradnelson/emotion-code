import UIKit

final class ChartColumnViewController: UICollectionViewController {

    var column: Chart.Column!
    var selectedSection: Int!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
    }

    private func updateTitle() {
        let column = (selectedSection + 2) % 2
        let row = selectedSection / 2 + 1
        let columnNames = ["A", "B"]
        navigationItem.title = "Row \(row) - Column \(columnNames[column])" // Localize
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
        destination.item = column.items[item]
    }

}
