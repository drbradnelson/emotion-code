import UIKit

// Mark: Main

class ChartRowToItemTransitionController: NSObject {

    private var itemPosition: ChartItemPosition?

}


// MARK: Transition

extension ChartRowToItemTransitionController {

    func goToRowDetails(fromViewController: ChartRowDetailsViewController, forItemPosition: ChartItemPosition) {

        self.itemPosition = forItemPosition
        fromViewController.performSegueWithIdentifier(ChartRowToItemTransitionController.itemDetailsSegueIdentifier, sender: self)
    }

    func finishTransition(forSegue segue: UIStoryboardSegue) {
        if segue.identifier == ChartRowToItemTransitionController.itemDetailsSegueIdentifier {
            segue.sourceViewController.navigationController!.delegate = self

            let rowDetailsViewController = segue.destinationViewController as! ChartItemDetailsViewController
            rowDetailsViewController.itemPosition = self.itemPosition!
            self.itemPosition = nil
        } else {
            preconditionFailure("unsuported transition")
        }
    }

}

// MARK: UINavigationController delegate

extension ChartRowToItemTransitionController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartRowDetailsViewController && toVC is ChartItemDetailsViewController {
            transition = ChartRowToItemTransition(direction: .Forward)
        }

        return transition
    }

}

// MARK: Constants

extension ChartRowToItemTransitionController {

    static private let itemDetailsSegueIdentifier = "ShowItemDetails"

}
