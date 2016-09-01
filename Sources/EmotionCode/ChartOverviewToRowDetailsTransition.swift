//
//  ChartOverviewTransition.swift
//  EmotionCode
//
//  Created by Andre Lami on 01/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

class ChartOverviewToRowDetailsTransition: NSObject {
    private var overviewController: ChartOverviewViewController!
    private var rowController: ChartRowDetailsViewController!
    private var containerView: UIView!
}

extension ChartOverviewToRowDetailsTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.prepare(withTransitionContex: transitionContext)

        let executors = self.createExecutors()
        executors.forEach { (executor) in
            executor.prepareBlock?()
        }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            executors.forEach { (executor) in
                executor.executeBlock()
            }
        }, completion: {(complete) in
            transitionContext.completeTransition(complete)
        })
    }
}

// MARK: Main cell transition

private extension ChartOverviewToRowDetailsTransition {
    func createExecutors() -> [TrasitionExecutor] {
        return [self.controllerTransition()]
    }
}

// MARK: Main controller transition

private extension ChartOverviewToRowDetailsTransition {

    func controllerTransition() -> TrasitionExecutor {

        let prepareBlock = {

            self.containerView.addSubview(self.rowController.view)
            self.rowController.view.alpha = 0
        }

        let animationBlock = {
            self.rowController.view.alpha = 1
        }

        let transitionExecutor = TrasitionExecutor.init(prepareBlock: prepareBlock, executeBlock: animationBlock)
        return transitionExecutor
    }
}

private extension ChartOverviewToRowDetailsTransition {
    private class TrasitionExecutor {
        let prepareBlock: (() -> ())?
        let executeBlock: () -> ()

        init(prepareBlock: (() -> ())?, executeBlock: () -> ()) {
            self.prepareBlock = prepareBlock
            self.executeBlock = executeBlock
        }
    }
}

private extension ChartOverviewToRowDetailsTransition {
    private func prepare(withTransitionContex context: UIViewControllerContextTransitioning) {
        self.overviewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartOverviewViewController
        self.rowController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartRowDetailsViewController

        self.containerView = context.containerView()

        // will trigger view drawing
        self.rowController.view.snapshotViewAfterScreenUpdates(true)
    }
}
