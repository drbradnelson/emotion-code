import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer!.isEnabled = false
    }

    // MARK: Navigation stack

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let collectionViewController = viewController as! UICollectionViewController
        collectionViewController.useLayoutToLayoutNavigationTransitions = !(viewController is ChartViewController)
        super.pushViewController(viewController, animated: animated)

        let masterCollectionView = (viewControllers[0] as! UICollectionViewController).collectionView!
        let chartLayout = (viewController as! UICollectionViewController).collectionViewLayout as! ChartLayout
        let chartPresenter = viewController as! ChartPresenter
        let chartLayoutMode = chartPresenter.chartLayoutMode(with: masterCollectionView)
        chartLayout.mode = chartLayoutMode
    }

}
