import Foundation
import UIKit

// MARK: Main

class ChartRowToItemTransition: NSObject {

    private (set) var rowDetailsController: ChartRowDetailsViewController!
    private (set) var itemDetailsController: ChartItemDetailsViewController!
    private (set) var containerView: UIView!
    private (set) var direction: TransitionDirection!
    private (set) var duration: NSTimeInterval!

    init(direction: TransitionDirection) {
        self.direction = direction
    }
}

// MARK: Transition params and data properties

protocol ChartRowToItemTransitionData {

    var rowDetailsController: ChartRowDetailsViewController! {get}
    var itemDetailsController: ChartItemDetailsViewController! {get}
    var containerView: UIView! {get}
    var direction: TransitionDirection! {get}
    var duration: NSTimeInterval! {get}

}

extension ChartRowToItemTransition: ChartRowToItemTransitionData {}

// MARK: UIViewControllerAnimatedTransitioning

extension ChartRowToItemTransition: UIViewControllerAnimatedTransitioning {

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

private extension ChartRowToItemTransition {

    func createExecutors(forData data: ChartRowToItemTransitionData) -> [TransitionExecutor] {
        return [self.createControllersTransition(forData: data), self.createItemViewTransition(forData: data)]

    }

}

// MARK: Prepare transition data and layout

private extension ChartRowToItemTransition {

    private func prepare(withTransitionContex context: UIViewControllerContextTransitioning) -> ChartRowToItemTransitionData {
        self.containerView = context.containerView()
        self.duration = self.transitionDuration(context)

        if self.direction == TransitionDirection.Forward {
            self.itemDetailsController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartItemDetailsViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartRowDetailsViewController
        } else {
            self.itemDetailsController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartItemDetailsViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartRowDetailsViewController

        }

        self.prepareLayoutForTranstion(forData: self)
        return self
    }

    private func prepareLayoutForTranstion(forData data: ChartRowToItemTransitionData) {
        let controller = self.value(data, forward: data.itemDetailsController, back: data.rowDetailsController)
        let collectionView = self.value(data, forward: data.itemDetailsController.contentView, back: data.rowDetailsController.rowDetailsView)

        // will trigger view drawing and correct layout
        data.containerView.addSubview(controller.view)
        controller.view.snapshotViewAfterScreenUpdates(true)
//        controller.view.removeFromSuperview()

        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }

}

// MARK: Helper methods

extension ChartRowToItemTransition {

    func value<ValType>(forData: ChartRowToItemTransitionData, forward: ValType, back: ValType) -> ValType {
        return TransitionValueSelector.selectVal(forDirection: forData.direction, forwarVal: forward, backwardVal: back)
    }

}
