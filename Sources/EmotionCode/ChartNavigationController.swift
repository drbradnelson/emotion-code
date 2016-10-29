import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let destination = viewController as? UICollectionViewController else { return }
        destination.collectionView?.delegate = destination

        destination.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        switch destination {
        case let destination as ChartColumnViewController:
            let column = (destination.selectedSection + 2) % 2
            let row = destination.selectedSection / 2 + 1
            let columnNames = ["A", "B"]
            destination.navigationItem.title = "Row \(row) - Column \(columnNames[column])"
        case let destination as ChartItemViewController:
            destination.navigationItem.title = destination.item.title
        default: break
        }
    }

}
