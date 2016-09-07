//
//  ChartOverviewToRowDetailsNeigboursTransitionExecutor.swift
//  EmotionCode
//
//  Created by Andre Lami on 02/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

extension ChartOverviewToRowDetailsTransition {
    
    func createNeighboursTransition(forData data:ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = overviewController.chartAdapter.indexPath(forRowPosition: chatRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell
        
        let overviewVisibleViews = self.fetchOverviewVisibleViews(forData: data)
        
        let overviewTransitionRowCellFrame = self.calculateOverviewTransitionRowCellBounds(forData: data)
        let rowDetailsFrame = self.calculateRowDetailsBounds(forData: data)
        
        let sizeAspect =  self.calculateItemsSizeAspec(forData: data)
        
        var executors = [TransitionExecutor]()
        
        let translationVector = CGPoint.init(x: rowDetailsFrame.midX - overviewTransitionRowCellFrame.midX, y: rowDetailsFrame.midY - overviewTransitionRowCellFrame.midY)
        let translation = CGAffineTransformMakeTranslation(translationVector.x, translationVector.y)
        let transform = CGAffineTransformScale(translation, sizeAspect, sizeAspect)
        
        for overviewVisibleView in overviewVisibleViews {
            
            if overviewVisibleView == overviewRowCell {
                continue
            }
            
            let overviewVisibleSnapshotContainer = UIView.init()
            let overviewVisibleViewFrame = data.overviewController.chartView.convertRect(overviewVisibleView.frame, toView: data.containerView)

            let overviewVisibleViewAnchorPoint = self.calculateOverviewVisibleViewAnchorPoint(forData: data, view: overviewVisibleView, andTransitionRowCellFrame: overviewTransitionRowCellFrame)
            
            data.containerView.addSubview(overviewVisibleSnapshotContainer)
            
            let overviewVisibleSnapshot = overviewVisibleView.snapshotViewAfterScreenUpdates(self.value(data, forward: false, back: true))
            overviewVisibleSnapshotContainer.addSubview(overviewVisibleSnapshot)
            overviewVisibleSnapshot.frame = CGRect.init(origin:CGPoint.init(x: 0, y: 0), size: overviewVisibleViewFrame.size)
            
            overviewVisibleSnapshotContainer.layer.anchorPoint = overviewVisibleViewAnchorPoint
            overviewVisibleSnapshotContainer.frame = overviewVisibleViewFrame

            
            let prepareBlock = {
                overviewVisibleSnapshotContainer.transform = self.value(data, forward: CGAffineTransformIdentity, back: transform)
                overviewVisibleSnapshotContainer.alpha = self.value(data, forward: 1, back: 0)
            }

            let animationBlock = {
                overviewVisibleSnapshotContainer.transform = self.value(data, forward: transform, back: CGAffineTransformIdentity)
                overviewVisibleSnapshotContainer.alpha = self.value(data, forward: 0, back: 1)
            }
            
            let completionBlock = { (cancelled: Bool) -> () in
                overviewVisibleSnapshotContainer.removeFromSuperview()
                overviewVisibleView.hidden = false
            }
            
            let executor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)
            executors.append(executor)
        }
        
        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: executors)
        return transitionExecutor
    }

    private func calculateRowDetailsBounds(forData data:ChartOverviewToRowDetailsTransitionData) -> CGRect {
        let rowDetailsItems = data.rowDetailsController.rowDetailsView.visibleCells()
        let rowDetailsTopItemView = rowDetailsItems.first!
        let rowDetailsBotItemView = rowDetailsItems.last!

        let rawFrame = CGRect.init(x: rowDetailsTopItemView.frame.minX, y: rowDetailsTopItemView.frame.minY, width: rowDetailsTopItemView.frame.width, height: rowDetailsBotItemView.frame.maxY - rowDetailsTopItemView.frame.minY)
        let frame = data.rowDetailsController.rowDetailsView.convertRect(rawFrame, toView: data.containerView)

        return frame
    }

    private func calculateOverviewTransitionRowCellBounds(forData data:ChartOverviewToRowDetailsTransitionData) -> CGRect {
        let chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chatRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell

        let fromFrameRaw = overviewRowCell.frame
        let frame = data.overviewController.chartView.convertRect(fromFrameRaw, toView: data.containerView)

        return frame
    }

    private func calculateItemsSizeAspec(forData data:ChartOverviewToRowDetailsTransitionData) -> CGFloat {
        let rowDetailsItems = data.rowDetailsController.rowDetailsView.visibleCells()
        let rowDetailsItem = rowDetailsItems.first!

        let chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chatRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell
        let overviewItem = overviewRowCell.itemViews!.first!

        let sizeAspect = rowDetailsItem.frame.width / overviewItem.frame.width
        return sizeAspect
    }
    
    private func fetchOverviewVisibleViews(forData data:ChartOverviewToRowDetailsTransitionData) -> [UIView] {
        let overviewVisibleItems: [UIView] = data.overviewController.chartView.visibleCells()
        let overviewVisibleColumnHeaders: [UIView] = data.overviewController.chartView.visibleSupplementaryViewsOfKind(ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier)
        let overviewVisibleCounters: [UIView] = data.overviewController.chartView.visibleSupplementaryViewsOfKind(ChartOverviewCollectionLayout.kRowCounterElementIdentifier)
        
        var overviewVisibleViews = [UIView]()
        overviewVisibleViews.appendContentsOf(overviewVisibleItems)
        overviewVisibleViews.appendContentsOf(overviewVisibleColumnHeaders)
        overviewVisibleViews.appendContentsOf(overviewVisibleCounters)
        
        return overviewVisibleViews

    }

    private func calculateOverviewVisibleViewAnchorPoint(forData data:ChartOverviewToRowDetailsTransitionData, view: UIView, andTransitionRowCellFrame frame:CGRect) -> CGPoint {
        let globAnchorPoint = CGPoint.init(x: frame.midX, y: frame.midY)
        let localAnchorPoint = data.containerView.convertPoint(globAnchorPoint, toView: view)
        let normAnchorPoint = CGPoint.init(x: localAnchorPoint.x / view.bounds.width, y: localAnchorPoint.y / view.bounds.height)

        return normAnchorPoint

    }
}