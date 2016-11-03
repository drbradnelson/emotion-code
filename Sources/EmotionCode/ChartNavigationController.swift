import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let collectionViewController = viewController as? UICollectionViewController {
            collectionViewController.useLayoutToLayoutNavigationTransitions = !(viewController is ChartViewController)
        }
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let destination = viewController as? UICollectionViewController else { return }
        destination.collectionView?.delegate = destination
        destination.collectionView?.isScrollEnabled = destination is ChartViewController
        destination.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
