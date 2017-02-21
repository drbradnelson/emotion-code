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
        if let collectionViewController = viewController as? UICollectionViewController {
            collectionViewController.useLayoutToLayoutNavigationTransitions = !(viewController is ChartViewController)
            if let chartPresenter = viewController as? ChartPresenter {
                let masterCollectionView = (viewControllers[0] as! UICollectionViewController).collectionView!

                viewController.loadViewIfNeeded()
                let chartLayout = (viewController as! UICollectionViewController).collectionViewLayout as! ChartLayout

                let chartLayoutMode = chartPresenter.chartLayoutMode(with: masterCollectionView)
                let sections = 0..<masterCollectionView.numberOfSections
                let itemsPerSection = sections.map(masterCollectionView.numberOfItems)
                let contentInset = masterCollectionView.contentInset
                chartLayout.program = ChartLayoutModule.makeProgram(delegate: chartLayout, flags: .init(
                    mode: chartLayoutMode,
                    itemsPerSection: itemsPerSection,
                    numberOfColumns: ChartLayout.numberOfColumns,
                    topContentInset: .init(contentInset.top),
                    bottomContentInset: .init(contentInset.bottom),
                    viewSize: .init(cgSize: masterCollectionView.visibleContentSize)
                ))
            }
        }
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
