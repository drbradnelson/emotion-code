import Foundation
import UIKit

// MARK: Main

class ChartOverviewToRowDetailsTransition: NSObject {

    private (set) var overviewController: ChartOverviewViewController!
    private (set) var rowDetailsController: ChartRowDetailsViewController!
    private (set) var containerView: UIView!
    private (set) var direction: TransitionDirection!
    private (set) var duration: NSTimeInterval!

    init(direction: TransitionDirection) {
        self.direction = direction
    }
}

// MARK: Transition params and data properties

protocol ChartOverviewToRowDetailsTransitionData {

    var overviewController: ChartOverviewViewController! {get}
    var rowDetailsController: ChartRowDetailsViewController! {get}
    var containerView: UIView! {get}
    var direction: TransitionDirection! {get}
    var duration: NSTimeInterval! {get}

}

extension ChartOverviewToRowDetailsTransition: ChartOverviewToRowDetailsTransitionData {}

// MARK: UIViewControllerAnimatedTransitioning

extension ChartOverviewToRowDetailsTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let transitionData = self.prepare(withTransitionContex: transitionContext)

        let executors = self.createExecutors(forData: transitionData)
        executors.forEach { $0.prepare() }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseOut, animations: {
            executors.forEach { $0.execute() }
        }) { (finished) in
            if !transitionContext.transitionWasCancelled() {
                executors.forEach { $0.complete() }
            } else {
                executors.forEach { $0.cancel() }
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

}

// MARK: Create executors

private extension ChartOverviewToRowDetailsTransition {

    func createExecutors(forData data: ChartOverviewToRowDetailsTransitionData) -> [TransitionExecutor] {

        // Alas, order of executors is important, they will add views to container view in correct order.
        // Controllers views are added in correct order, and then transition elements snapshots
        return [self.createControllersTransition(forData: data), self.createMainRowTransition(forData: data), self.createNeighboursTransition(forData: data)]

    }

}

// MARK: Prepare transition data and layout

private extension ChartOverviewToRowDetailsTransition {

    private func prepare(withTransitionContex context: UIViewControllerContextTransitioning) -> ChartOverviewToRowDetailsTransitionData {
        self.containerView = context.containerView()
        self.duration = self.transitionDuration(context)

        if self.direction == TransitionDirection.Forward {
            self.overviewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartOverviewViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartRowDetailsViewController
        } else {
            self.overviewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartOverviewViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartRowDetailsViewController

        }

        self.prepareLayoutForTranstion(forData: self)
        return self
    }

    private func prepareLayoutForTranstion(forData data: ChartOverviewToRowDetailsTransitionData) {
        let controller = self.value(data, forward: data.rowDetailsController, back: data.overviewController)
        let collectionView = self.value(data, forward: data.rowDetailsController.rowDetailsView, back: data.overviewController.chartView)

        // will trigger view drawing and correct layout
        data.containerView.addSubview(controller.view)
        controller.view.snapshotViewAfterScreenUpdates(true)
        controller.view.removeFromSuperview()

        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }

}

// MARK: Helper methods

extension ChartOverviewToRowDetailsTransition {

    func value<ValType>(forData: ChartOverviewToRowDetailsTransitionData, forward: ValType, back: ValType) -> ValType {
        return TransitionValueSelector.selectVal(forDirection: forData.direction, forwarVal: forward, backwardVal: back)
    }

}
