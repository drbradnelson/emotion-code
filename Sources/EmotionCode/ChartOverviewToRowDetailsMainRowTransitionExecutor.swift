import UIKit

extension ChartOverviewToRowDetailsTransition {

    private struct ItemTransitionInfo {
        init() {}

        var overviewItemFrame: CGRect!
        var rowDetailsItemFrame: CGRect!

        var overviewItemBackgroundColor: UIColor!
        var rowDetailsItemBackgroundColor: UIColor!
    }

    private struct ItemTransitionViews {
        init() {}

        var itemTransitionContainer: UIView!
        var overviewItemTransitionView: UIView!
        var rowDetailsItemTransitionView: UIView!
    }

    func createMainRowTransition(forData data: ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let chartRowPosition = data.rowDetailsController.chartRowPosition!
        let overviewRowCellIndexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chartRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(overviewRowCellIndexPath) as! ChartOverviewRowCell

        var executors = [TransitionExecutor]()
        for (index, _) in overviewRowCell.itemViews!.enumerate() {

            let rowDetailsItemIndexPath = NSIndexPath(forItem: index, inSection: 0)
            let rowDetailsItemView = data.rowDetailsController.rowDetailsView.cellForItemAtIndexPath(rowDetailsItemIndexPath)!

            let itemTransitionViews = createItemTransitionViews(forOverviewRowCell: overviewRowCell, forItemAtIndex: index, forData: data)
            let itemTransitionInfo = createItemTransitionInfo(forOverviewRowCell: overviewRowCell, forItemAtIndex: index, forRowDetailsItemView: rowDetailsItemView, forData: data)

            let executor = createItemViewExecutor(forData: data, forItemTransitionViews: itemTransitionViews, andTransitionInfo: itemTransitionInfo)
            executors.append(executor)
        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: executors)
        return transitionExecutor
    }
}

// MARK: Helper methods

private extension ChartOverviewToRowDetailsTransition {

    func createItemViewExecutor(forData data: ChartOverviewToRowDetailsTransitionData, forItemTransitionViews transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) -> TransitionExecutor {

        let prepareBlock = {
            self.prepareItemTransitionContainerView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
            self.prepareOverviewItemTransitionView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
            self.prepareRowDetailsItemTransitionView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
        }

        let animationBlock = {
            transitionViews.rowDetailsItemTransitionView.alpha = self.value(data, forward: 1, back: 0)
            transitionViews.overviewItemTransitionView.alpha = self.value(data, forward: 0, back: 1)

            transitionViews.itemTransitionContainer.backgroundColor = self.value(data, forward: info.rowDetailsItemBackgroundColor, back: info.overviewItemBackgroundColor)
            transitionViews.itemTransitionContainer.frame = self.value(data, forward: info.rowDetailsItemFrame, back: info.overviewItemFrame)
        }

        let completionBlock: (Bool) -> () = { (cancelled) -> () in
            transitionViews.itemTransitionContainer.removeFromSuperview()
        }

        return TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)
    }

    func prepareItemTransitionContainerView(forData data: ChartOverviewToRowDetailsTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        data.containerView.addSubview(transitionViews.itemTransitionContainer)

        transitionViews.itemTransitionContainer.backgroundColor = value(data, forward: info.overviewItemBackgroundColor, back: info.rowDetailsItemBackgroundColor)
        transitionViews.itemTransitionContainer.frame = value(data, forward: info.overviewItemFrame, back: info.rowDetailsItemFrame)
    }

    func prepareOverviewItemTransitionView(forData data: ChartOverviewToRowDetailsTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        let centerFrame = value(data, forward: info.overviewItemFrame, back: info.rowDetailsItemFrame)

        transitionViews.overviewItemTransitionView.frame = CGRect(origin: CGPoint.zero, size: info.overviewItemFrame.size)
        transitionViews.overviewItemTransitionView.center = CGPoint(x: centerFrame.width / 2, y: centerFrame.height / 2)
        transitionViews.overviewItemTransitionView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]

        transitionViews.overviewItemTransitionView.alpha = value(data, forward: 1, back: 0)
    }

    func prepareRowDetailsItemTransitionView(forData data: ChartOverviewToRowDetailsTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        let centerFrame = value(data, forward: info.overviewItemFrame, back: info.rowDetailsItemFrame)
        transitionViews.rowDetailsItemTransitionView.frame = CGRect(origin: CGPoint.zero, size: info.rowDetailsItemFrame.size)
        transitionViews.rowDetailsItemTransitionView.center = CGPoint(x: centerFrame.width / 2, y: centerFrame.height / 2)
        transitionViews.rowDetailsItemTransitionView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]

        transitionViews.rowDetailsItemTransitionView.alpha = value(data, forward: 0, back: 1)
    }

    func createItemTransitionViews(forOverviewRowCell overviewRowCell: ChartOverviewRowCell, forItemAtIndex index: Int, forData data: ChartOverviewToRowDetailsTransitionData) -> ItemTransitionViews {

        var transitionViews = ItemTransitionViews()

        let overviewItemView = overviewRowCell.itemViews![index]

        let rowDetailsItemIndexPath = NSIndexPath(forItem: index, inSection: 0)
        let rowDetailsItemView = data.rowDetailsController.rowDetailsView.cellForItemAtIndexPath(rowDetailsItemIndexPath)!

        transitionViews.itemTransitionContainer = UIView()
        transitionViews.itemTransitionContainer.clipsToBounds = true

        transitionViews.overviewItemTransitionView = overviewItemView.snapshotViewAfterScreenUpdates(value(data, forward: false, back: true))
        transitionViews.itemTransitionContainer.addSubview(transitionViews.overviewItemTransitionView)

        transitionViews.rowDetailsItemTransitionView = rowDetailsItemView.snapshotViewAfterScreenUpdates(value(data, forward: true, back: false))
        transitionViews.itemTransitionContainer.addSubview(transitionViews.rowDetailsItemTransitionView)

        return transitionViews
    }

    func createItemTransitionInfo(forOverviewRowCell overviewRowCell: ChartOverviewRowCell, forItemAtIndex index: Int, forRowDetailsItemView rowDetailsItemView: UIView, forData data: ChartOverviewToRowDetailsTransitionData) -> ItemTransitionInfo {

        var transitionInfo = ItemTransitionInfo()

        let overviewItemView = overviewRowCell.itemViews![index]
        transitionInfo.overviewItemFrame = overviewRowCell.convertRect(overviewItemView.frame, toView: data.containerView)
        transitionInfo.rowDetailsItemFrame = data.rowDetailsController.rowDetailsView.convertRect(rowDetailsItemView.frame, toView: data.containerView)

        transitionInfo.overviewItemBackgroundColor = overviewItemView.backgroundColor
        transitionInfo.rowDetailsItemBackgroundColor = rowDetailsItemView.backgroundColor

        return transitionInfo
    }
}
