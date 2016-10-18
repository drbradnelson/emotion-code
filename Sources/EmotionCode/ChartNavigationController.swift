import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ChartViewController {
            vc.collectionView?.dataSource = vc
        } else if let vc = viewController as? ChartColumnViewController {
            vc.collectionView?.delegate = vc
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ChartColumnViewController {
            vc.collectionView?.dataSource = vc
        }
    }

}
