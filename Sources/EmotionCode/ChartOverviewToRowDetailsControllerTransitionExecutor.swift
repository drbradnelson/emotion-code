//
//  ChartOverviewToRowDetailsControllerTransitionExecutor.swift
//  EmotionCode
//
//  Created by Andre Lami on 02/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

extension ChartOverviewToRowDetailsTransition {
    
    func createControllersTransition(forData data:ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let overviewTransitionCoverView = UIView.init()
        overviewTransitionCoverView.frame = data.containerView.bounds
        overviewTransitionCoverView.backgroundColor = data.overviewController.view.backgroundColor
        
        let prepareBlock = {
            
            self.rowDetailsController.rowDetailsView.hidden = true
            
            if data.direction == TransitionDirection.Forward {
                data.containerView.addSubview(data.rowDetailsController.view)
                data.rowDetailsController.view.alpha = 0
                data.containerView.insertSubview(overviewTransitionCoverView, aboveSubview: self.overviewController.view)
                
            } else {
                self.containerView.insertSubview(overviewTransitionCoverView, belowSubview: self.rowDetailsController.view)
                data.containerView.insertSubview(data.overviewController.view, belowSubview: overviewTransitionCoverView)
            }
        }
        
        let animationBlock = {
            self.rowDetailsController.view.alpha = self.value(data, forward: 1, back: 0)
        }
        
        let completionBlock = { (cancelled: Bool) -> () in
            self.rowDetailsController.rowDetailsView.hidden = false
            overviewTransitionCoverView.removeFromSuperview()
        }
        
        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)
        
        return transitionExecutor
    }
}