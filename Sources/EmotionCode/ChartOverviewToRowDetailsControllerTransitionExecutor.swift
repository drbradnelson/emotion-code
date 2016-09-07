//
//  ChartOverviewToRowDetailsControllerTransitionExecutor.swift
//  EmotionCode
//
//  Created by Andre Lami on 02/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation

extension ChartOverviewToRowDetailsTransition {
    
    func createControllersTransition(withData data:ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let prepareBlock = {
            
            if data.direction == TransitionDirection.Forward {
                data.containerView.addSubview(data.rowDetailsController.view)
                data.rowDetailsController.view.alpha = 0
                
            } else {
//                data.containerView.addSubview(data.overviewController.view)
                data.containerView.insertSubview(data.overviewController.view, belowSubview: data.rowDetailsController.view)
            }
            
            data.rowDetailsController.rowDetailsView.hidden = true
        }
        
        let animationBlock = {
            self.rowDetailsController.view.alpha = self.value(data, forward: 1, back: 0)
        }
        
        let completionBlock = { (finished: Bool) -> () in
            self.rowDetailsController.rowDetailsView.hidden = false
        }
        
        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)
        
        return transitionExecutor
    }
}