import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as? UICollectionViewController
        vc?.collectionView?.delegate = vc

        vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        switch vc {
        case let vc as ChartColumnViewController:
            let column = (vc.selectedSection + 2) % 2
            let row = vc.selectedSection / 2 + 1
            let columnNames = ["A", "B"]
            vc.navigationItem.title = "Row \(row) - Column \(columnNames[column])"
        case let vc as ChartItemViewController:
            vc.navigationItem.title = vc.item.title
        default: break
        }
    }

}
