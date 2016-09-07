//
//  ChartOverviewTransitionController.swift
//  EmotionCode
//
//  Created by Andre Lami on 01/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

// MARK: Main

class ChartOverviewTransitionController: NSObject {
    private var rowDetailsRowPosition: ChartRowPosition?
}

// MARK: Transition

extension ChartOverviewTransitionController {
    func goToRowDetails(fromViewController: ChartOverviewViewController, forRowPosition: ChartRowPosition) {

        self.rowDetailsRowPosition = forRowPosition
        fromViewController.performSegueWithIdentifier(ChartOverviewTransitionController.rowDetailsSegueIdentifier, sender: self)
    }

    func finishTransition(forSegue segue: UIStoryboardSegue) {
        if segue.identifier == ChartOverviewTransitionController.rowDetailsSegueIdentifier {
            segue.sourceViewController.navigationController!.delegate = self

            let rowDetailsViewController = segue.destinationViewController as! ChartRowDetailsViewController
            rowDetailsViewController.chartRowPosition = self.rowDetailsRowPosition
            self.rowDetailsRowPosition = nil
        } else {
            preconditionFailure("unsuported transition")
        }
    }
}

// MARK: UINavigationController delegate

extension ChartOverviewTransitionController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartOverviewViewController && toVC is ChartRowDetailsViewController {
            transition = ChartOverviewToRowDetailsTransition.init()
        }

        return transition
    }
}

// MARK: Constants

extension ChartOverviewTransitionController {
    static private let rowDetailsSegueIdentifier = "ShowRowDetails"
}
