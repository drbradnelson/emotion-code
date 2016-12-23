import UIKit

final class ChartNavigationController: UINavigationController, UINavigationControllerDelegate {

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    // MARK: Navigation stack

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let collectionViewController = viewController as? UICollectionViewController {
            collectionViewController.useLayoutToLayoutNavigationTransitions = !(viewController is ChartViewController)
            if let chartPresenter = viewController as? ChartPresenter {
                let masterCollectionView = (viewControllers[0] as! UICollectionViewController).collectionView!

                viewController.loadViewIfNeeded()
                let chartLayout = (viewController as! UICollectionViewController).collectionViewLayout as! ChartLayout

                let sections = 0..<masterCollectionView.numberOfSections
                let itemsPerSection = sections.map(masterCollectionView.numberOfItems)
                let viewSize = masterCollectionView.visibleContentSize
                chartLayout.provideData(itemsPerSection: itemsPerSection, viewSize: viewSize)

                let chartLayoutMode = chartPresenter.chartLayoutMode(with: masterCollectionView)
                chartLayout.setMode(chartLayoutMode)
            }
        }
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let destination = viewController as? UICollectionViewController else { return }
        destination.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
