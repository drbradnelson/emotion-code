import UIKit

// MARK: Main

class ChartItemDetailsTransitionController: NSObject {

    weak private var chartItemDetailsViewController: ChartItemDetailsViewController!

    private var interactionInProgress = false
    private var shouldCompleteTransition = false
    private var runningTransition: UIPercentDrivenInteractiveTransition? = nil

    private let transitionProgressCoefficient: CGFloat = 200

    init(chartItemDetailsViewController: ChartItemDetailsViewController) {
        self.chartItemDetailsViewController = chartItemDetailsViewController
        super.init()

        self.setup()
    }
}

// MARK: Setup

private extension ChartItemDetailsTransitionController {

    func setup() {
        self.chartItemDetailsViewController.navigationController?.delegate = self

        let transitionGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        transitionGR.edges = UIRectEdge.Left
        self.chartItemDetailsViewController.view.addGestureRecognizer(transitionGR)

    }

}


// MARK: Transition

extension ChartItemDetailsTransitionController {

    func goToRowDetails(fromViewController: ChartItemDetailsViewController) {
        fromViewController.navigationController!.popViewControllerAnimated(true)
    }

    func handleTransition(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            self.startInteractiveTransition()
        case .Changed:
            let progress = calculateProgress(forTransitionGesture: gestureRecognizer)
            self.updateInteractiveTransition(withProgress: progress)
        case .Cancelled:
            self.cancelInteractiveTransition()
        case .Ended:
            self.finishInteractiveTrnasition()
        default:
            print("Unsupported")
        }
    }

    func startInteractiveTransition() {
        interactionInProgress = true
        self.goToRowDetails(self.chartItemDetailsViewController)
    }

    func updateInteractiveTransition(withProgress progress: CGFloat) {
        shouldCompleteTransition = progress > 0.5
        self.runningTransition?.updateInteractiveTransition(progress)
    }

    func cancelInteractiveTransition() {
        interactionInProgress = false
        self.runningTransition?.cancelInteractiveTransition()
    }

    func finishInteractiveTrnasition() {
        interactionInProgress = false

        if !shouldCompleteTransition {
            self.runningTransition?.cancelInteractiveTransition()
        } else {
            self.runningTransition?.finishInteractiveTransition()
        }

        self.runningTransition = nil
    }

}

// MARK: UINavigationController delegate

extension ChartItemDetailsTransitionController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartItemDetailsViewController && toVC is ChartRowDetailsViewController {
            transition = ChartRowToItemTransition(direction: .Backward)
        }

        return transition
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactionInProgress {
            self.runningTransition = UIPercentDrivenInteractiveTransition()
            return self.runningTransition
        } else {
            return nil
        }
    }

}

// MARK: Constants

extension ChartItemDetailsTransitionController {

    static private let rowDetailsSegueIdentifier = "ShowRowDetails"

}

// MARK: Helper methods

extension ChartItemDetailsTransitionController {

    func calculateProgress(forTransitionGesture gestureRecognizer: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        var progress = (translation.x / transitionProgressCoefficient)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        return progress
    }

}
