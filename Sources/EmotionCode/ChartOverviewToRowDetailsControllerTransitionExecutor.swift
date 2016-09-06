import Foundation
import UIKit

extension ChartOverviewToRowDetailsTransition {

    func createControllersTransition(forData data: ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let overviewControllerTransition = self.createOverviewControllerExecutor(forData: data)
        let rowDetailsControllerTransition = self.createRowDetailsControllerExecutor(forData: data)

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: [overviewControllerTransition, rowDetailsControllerTransition])

        return transitionExecutor
    }

    private func createOverviewControllerExecutor(forData data: ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let overviewTransitionCoverView = UIView()
        overviewTransitionCoverView.frame = data.containerView.bounds
        overviewTransitionCoverView.backgroundColor = data.overviewController.view.backgroundColor

        let prepareBlock = {
            if data.direction == TransitionDirection.Forward {
                data.containerView.insertSubview(overviewTransitionCoverView, aboveSubview: data.overviewController.view)
            } else {
                data.containerView.insertSubview(overviewTransitionCoverView, belowSubview: data.rowDetailsController.view)
                data.containerView.insertSubview(data.overviewController.view, belowSubview: overviewTransitionCoverView)
            }
        }

        let completionBlock = { (cancelled: Bool) -> () in
            overviewTransitionCoverView.removeFromSuperview()
        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: {}, completionBlock: completionBlock)

        return transitionExecutor
    }

    private func createRowDetailsControllerExecutor(forData data: ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let prepareBlock = {
            data.rowDetailsController.rowDetailsView.hidden = true
            if data.direction == TransitionDirection.Forward {
                data.containerView.addSubview(data.rowDetailsController.view)
                data.rowDetailsController.view.alpha = 0
            }
        }

        let animationBlock = {
            data.rowDetailsController.view.alpha = self.value(data, forward: 1, back: 0)
        }

        let completionBlock = { (cancelled: Bool) -> () in
            data.rowDetailsController.rowDetailsView.hidden = false
        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)

        return transitionExecutor
    }
}
