import UIKit

extension ChartRowToItemTransition {

    func createControllersTransition(forData data: ChartRowToItemTransitionData) -> TransitionExecutor {
        let rowDetailsControllerTransition = self.createRowDetailsControllerExecutor(forData: data)
        let itemDetailsControllerTransition = self.createItemDetailsControllerExecutor(forData: data)

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: [rowDetailsControllerTransition, itemDetailsControllerTransition])

        return transitionExecutor
    }

    private func createRowDetailsControllerExecutor(forData data: ChartRowToItemTransitionData) -> TransitionExecutor {

        data.containerView.insertSubview(data.rowDetailsController.view, belowSubview: data.containerView)

        let prepareBlock = {
            if data.direction == TransitionDirection.Backward {
                data.rowDetailsController.view.alpha = 0.0
            }
        }

        let animationBlock = {
            data.rowDetailsController.view.alpha = 1.0
        }

        let completionBlock = { (cancelled: Bool) -> () in

        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)

        return transitionExecutor
    }

    private func createItemDetailsControllerExecutor(forData data: ChartRowToItemTransitionData) -> TransitionExecutor {
        let prepareBlock = {
            if data.direction == TransitionDirection.Forward {
                data.containerView.addSubview(data.itemDetailsController.view)
                data.itemDetailsController.view.alpha = 0
            }
        }

        let completionBlock = { (cancelled: Bool) -> () in
            data.itemDetailsController.view.alpha = 1.0
        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: {}, completionBlock: completionBlock)

        return transitionExecutor
    }

}
