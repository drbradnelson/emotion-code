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
                let topContentInset = masterCollectionView.contentInset.top
                chartLayout.program = ChartLayoutModule.makeProgram(flags: .init(
                    mode: chartLayoutMode,
                    itemsPerSection: itemsPerSection,
                    numberOfColumns: ChartLayout.numberOfColumns,
                    topContentInset: Int(topContentInset)
                ))
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
