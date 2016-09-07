import UIKit


extension ChartOverviewToRowDetailsTransition {
    
    func createMainRowTransition(forData data:ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let chartRowPosition = data.rowDetailsController.chartRowPosition!
        let overviewRowCellIndexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chartRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(overviewRowCellIndexPath) as! ChartOverviewRowCell
        
        var executors = [TransitionExecutor]()
        for (index, overviewItemView) in overviewRowCell.itemViews!.enumerate() {
            
            let rowDetailsItemIndexPath = NSIndexPath.init(forItem: index, inSection: 0)
            let rowDetailsItemView = data.rowDetailsController.rowDetailsView.cellForItemAtIndexPath(rowDetailsItemIndexPath)!

            let overviewItemFrame = overviewRowCell.convertRect(overviewItemView.frame, toView: data.containerView)
            let rowDetailsItemFrame = data.rowDetailsController.rowDetailsView.convertRect(rowDetailsItemView.frame, toView: data.containerView)

            let itemTransitionContainerView = UIView.init()
            itemTransitionContainerView.clipsToBounds = true

            let overviewItemViewSnapshot = overviewItemView.snapshotViewAfterScreenUpdates(self.value(data, forward: false, back: true))
            itemTransitionContainerView.addSubview(overviewItemViewSnapshot)
            itemTransitionContainerView.frame = overviewItemFrame
            overviewItemViewSnapshot.frame = itemTransitionContainerView.bounds
            overviewItemViewSnapshot.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]

            let rowDetailsItemViewSnapshot = rowDetailsItemView.snapshotViewAfterScreenUpdates(self.value(data, forward: true, back: false))
            itemTransitionContainerView.addSubview(rowDetailsItemViewSnapshot)
            rowDetailsItemViewSnapshot.frame = CGRect.init(origin: CGPoint.zero, size: rowDetailsItemFrame.size)
            rowDetailsItemViewSnapshot.center = CGPoint.init(x: overviewItemFrame.width / 2, y: overviewItemFrame.height / 2)
            rowDetailsItemViewSnapshot.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
            
            let prepareBlock = {
                
                data.containerView.addSubview(itemTransitionContainerView)

                rowDetailsItemViewSnapshot.alpha = self.value(data, forward: 0, back: 1)
                overviewItemViewSnapshot.alpha = self.value(data, forward: 1, back: 0)

                itemTransitionContainerView.backgroundColor = self.value(data, forward: overviewItemView.backgroundColor, back: rowDetailsItemView.backgroundColor)
                itemTransitionContainerView.frame = self.value(data, forward: overviewItemFrame, back: rowDetailsItemFrame)
            }

            let animationBlock = {
                rowDetailsItemViewSnapshot.alpha = self.value(data, forward: 1, back: 0)
                overviewItemViewSnapshot.alpha = self.value(data, forward: 0, back: 1)

                itemTransitionContainerView.backgroundColor = self.value(data, forward: rowDetailsItemView.backgroundColor, back: overviewItemView.backgroundColor)
                itemTransitionContainerView.frame = self.value(data, forward: rowDetailsItemFrame, back: overviewItemFrame)
            }
            
            let completionBlock: (Bool) -> () = { (cancelled) -> () in
                itemTransitionContainerView.removeFromSuperview()
            }
            
            let executor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)
            executors.append(executor)
        }
        
        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: executors)
        return transitionExecutor
    }
}