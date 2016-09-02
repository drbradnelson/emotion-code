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
    
    private (set) var overviewController: ChartOverviewViewController!
    private (set) var rowDetailsController: ChartRowDetailsViewController!
    private (set) var containerView: UIView!
    private (set) var direction: TransitionDirection!
    private (set) var duration: NSTimeInterval!
    
    init(direction: TransitionDirection) {
        self.direction = direction
    }
}

extension ChartOverviewToRowDetailsTransition {
    func value<ValType>(forData:ChartOverviewToRowDetailsTransitionData, forward: ValType, back: ValType) -> ValType {
        return TransitionValueSelector.selectVal(forDirection: forData.direction, forwarVal: forward, backwardVal: back)
    }
}

protocol ChartOverviewToRowDetailsTransitionData {
    var overviewController: ChartOverviewViewController! {get}
    var rowDetailsController: ChartRowDetailsViewController!  {get}
    var containerView: UIView! {get}
    var direction: TransitionDirection! {get}
    var duration: NSTimeInterval! {get}
}

extension ChartOverviewToRowDetailsTransition: ChartOverviewToRowDetailsTransitionData {}

extension ChartOverviewToRowDetailsTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.prepare(withTransitionContex: transitionContext)

        let executors = self.createExecutors()
        executors.forEach { (executor) in
            executor.prepare()
        }
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseOut, animations: {
            executors.forEach { (executor) in
                executor.execute()
            }
        }) { (finished) in
            executors.forEach { (executor) in
                executor.complete(finished)
            }
            
            transitionContext.completeTransition(finished)
        }   
    }
}

extension ChartOverviewToRowDetailsTransition {
    func snp(view: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return UIImageView.init(image: img);
    }
}

// MARK: Main cell transition

private extension ChartOverviewToRowDetailsTransition {
    func createExecutors() -> [TransitionExecutor] {
        if self.direction == TransitionDirection.Forward {
        return [self.createControllersTransition(withData: self), self.createMainRowTransition(withData: self), self.createNeighboursTransition(withData: self)]
        } else {
            return [self.createControllersTransition(withData: self), self.createMainRowTransition(withData: self), self.createNeighboursTransition(withData: self)]
        }
        
    }
}

private extension ChartOverviewToRowDetailsTransition {
    private func prepare(withTransitionContex context: UIViewControllerContextTransitioning) {
        if self.direction == TransitionDirection.Forward {
            self.overviewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartOverviewViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartRowDetailsViewController
        } else {
            self.overviewController = context.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChartOverviewViewController
            self.rowDetailsController = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ChartRowDetailsViewController
        }
        

        self.containerView = context.containerView()
        self.duration = self.transitionDuration(context)
        
        let controller = self.value(self, forward: self.rowDetailsController, back: self.overviewController)
        let collectionView = self.value(self, forward: self.rowDetailsController.rowDetailsView, back: self.overviewController.chartView)
        
        // will trigger view drawing and correct layout
        self.containerView.addSubview(controller.view)
        controller.view.snapshotViewAfterScreenUpdates(true)
        controller.view.removeFromSuperview()
        
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
}