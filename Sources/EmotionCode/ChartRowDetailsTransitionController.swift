import UIKit

// MARK: Main

class ChartRowDetailsTransitionController: NSObject {

    weak private var chartRowDetailsViewController: ChartRowDetailsViewController!

    private var interactionInProgress = false
    private var shouldCompleteTransition = false
    private var runningTransition: UIPercentDrivenInteractiveTransition? = nil

    private let transitionProgressCoefficient: CGFloat = 200

    init(chartRowDetailsViewController: ChartRowDetailsViewController) {
        self.chartRowDetailsViewController = chartRowDetailsViewController
        super.init()

        self.setup()
    }
}

// MARK: Setup

private extension ChartRowDetailsTransitionController {
    func setup() {
        self.chartRowDetailsViewController.navigationController?.delegate = self

        let transitionGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        transitionGR.edges = UIRectEdge.Left
        self.chartRowDetailsViewController.view.addGestureRecognizer(transitionGR)
    }
}


// MARK: Transition

extension ChartRowDetailsTransitionController {
    func goToOverview(fromViewController: ChartRowDetailsViewController) {
        fromViewController.navigationController!.popViewControllerAnimated(true)
    }

    func handleTransition(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .Began:
                self.startInteractiveTransition()
            case .Changed:
                let progress = self.calculateProgress(forTransitionGesture: gestureRecognizer)
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
        self.goToOverview(self.chartRowDetailsViewController)
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

extension ChartRowDetailsTransitionController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartRowDetailsViewController && toVC is ChartOverviewViewController {
            transition = ChartOverviewToRowDetailsTransition(direction: .Backward)
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

extension ChartRowDetailsTransitionController {
    static private let rowDetailsSegueIdentifier = "ShowRowDetails"
}

// MARK: Helper methods

extension ChartRowDetailsTransitionController {
    func calculateProgress(forTransitionGesture gestureRecognizer: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        var progress = (translation.x / self.transitionProgressCoefficient)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        return progress
    }
}
