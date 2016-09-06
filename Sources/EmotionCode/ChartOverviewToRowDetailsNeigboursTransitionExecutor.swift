import UIKit

extension ChartOverviewToRowDetailsTransition {

    private struct NeigboursTransitionInfo {
        init() {}

        var chatRowPosition: ChartRowPosition!
        var overviewRowCell: ChartOverviewRowCell!
        var overviewVisibleViews: [UIView]!

        var overviewTransitionRowCellFrame: CGRect!

        var sizeAspect: CGFloat!
        var transform: CGAffineTransform!
    }

    func createNeighboursTransition(forData data: ChartOverviewToRowDetailsTransitionData) -> TransitionExecutor {
        let info = self.createTransitionInfo(forData: data)
        var executors = [TransitionExecutor]()
        for overviewVisibleView in info.overviewVisibleViews {

            if overviewVisibleView == info.overviewRowCell {
                continue
            }

            let overviewTransitionContainer = self.createOverviewTransitionContainer(forView: overviewVisibleView, data: data, andInfo: info)
            let executor = self.createExecutor(forOverviewTransitionContainer: overviewTransitionContainer, data: data, andInfo: info)
            executors.append(executor)
        }

        let transitionExecutor = TransitionExecutorFactory.transitionExecutor(withExecutors: executors)
        return transitionExecutor
    }

}

// MARK: Helpers

extension ChartOverviewToRowDetailsTransition {

    private func createTransitionInfo(forData data: ChartOverviewToRowDetailsTransitionData) -> NeigboursTransitionInfo {
        var info: NeigboursTransitionInfo = NeigboursTransitionInfo()
        info.chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = overviewController.chartAdapter.indexPath(forRowPosition: info.chatRowPosition)
        info.overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell

        info.overviewVisibleViews = self.fetchOverviewVisibleViews(forData: data)

        info.overviewTransitionRowCellFrame = self.calculateOverviewTransitionRowCellBounds(forData: data)
        let rowDetailsFrame = self.calculateRowDetailsBounds(forData: data)

        info.sizeAspect =  self.calculateItemsSizeAspec(forData: data)

        let translationVector = CGPoint(x: rowDetailsFrame.midX - info.overviewTransitionRowCellFrame.midX, y: rowDetailsFrame.midY - info.overviewTransitionRowCellFrame.midY)
        let translation = CGAffineTransformMakeTranslation(translationVector.x, translationVector.y)
        info.transform = CGAffineTransformScale(translation, info.sizeAspect, info.sizeAspect)
        return info
    }

    private func createOverviewTransitionContainer(forView overviewView: UIView, data: ChartOverviewToRowDetailsTransitionData, andInfo info: NeigboursTransitionInfo) -> UIView {
        let overviewVisibleTransitionContainer = UIView()
        let overviewVisibleViewFrame = data.overviewController.chartView.convertRect(overviewView.frame, toView: data.containerView)

        let overviewVisibleViewAnchorPoint = self.calculateOverviewVisibleViewAnchorPoint(forData: data, view: overviewView, andTransitionRowCellFrame: info.overviewTransitionRowCellFrame)

        data.containerView.addSubview(overviewVisibleTransitionContainer)

        let overviewVisibleSnapshot = overviewView.snapshotViewAfterScreenUpdates(self.value(data, forward: false, back: true))
        overviewVisibleTransitionContainer.addSubview(overviewVisibleSnapshot)
        overviewVisibleSnapshot.frame = CGRect(origin:CGPoint(x: 0, y: 0), size: overviewVisibleViewFrame.size)

        overviewVisibleTransitionContainer.layer.anchorPoint = overviewVisibleViewAnchorPoint
        overviewVisibleTransitionContainer.frame = overviewVisibleViewFrame

        return overviewVisibleTransitionContainer
    }

    private func createExecutor(forOverviewTransitionContainer container: UIView, data: ChartOverviewToRowDetailsTransitionData, andInfo info: NeigboursTransitionInfo) -> TransitionExecutor {
        let prepareBlock = {
            container.transform = self.value(data, forward: CGAffineTransformIdentity, back: info.transform)
            container.alpha = self.value(data, forward: 1, back: 0)
        }

        let animationBlock = {
            container.transform = self.value(data, forward: info.transform, back: CGAffineTransformIdentity)
            container.alpha = self.value(data, forward: 0, back: 1)
        }

        let completionBlock = { (cancelled: Bool) -> () in
            container.removeFromSuperview()
        }

        let executor = TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: animationBlock, completionBlock: completionBlock)

        return executor
    }

    private func calculateRowDetailsBounds(forData data: ChartOverviewToRowDetailsTransitionData) -> CGRect {
        let rowDetailsItems = data.rowDetailsController.rowDetailsView.visibleCells()
        let rowDetailsTopItemView = rowDetailsItems.first!
        let rowDetailsBotItemView = rowDetailsItems.last!

        let rawFrame = CGRect(x: rowDetailsTopItemView.frame.minX, y: rowDetailsTopItemView.frame.minY, width: rowDetailsTopItemView.frame.width, height: rowDetailsBotItemView.frame.maxY - rowDetailsTopItemView.frame.minY)
        let frame = data.rowDetailsController.rowDetailsView.convertRect(rawFrame, toView: data.containerView)

        return frame
    }

    private func calculateOverviewTransitionRowCellBounds(forData data: ChartOverviewToRowDetailsTransitionData) -> CGRect {
        let chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chatRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell

        let fromFrameRaw = overviewRowCell.frame
        let frame = data.overviewController.chartView.convertRect(fromFrameRaw, toView: data.containerView)

        return frame
    }

    private func calculateItemsSizeAspec(forData data: ChartOverviewToRowDetailsTransitionData) -> CGFloat {
        let rowDetailsItems = data.rowDetailsController.rowDetailsView.visibleCells()
        let rowDetailsItem = rowDetailsItems.first!

        let chatRowPosition = rowDetailsController.chartRowPosition!
        let indexPath = data.overviewController.chartAdapter.indexPath(forRowPosition: chatRowPosition)
        let overviewRowCell = data.overviewController.chartView.cellForItemAtIndexPath(indexPath) as! ChartOverviewRowCell
        let overviewItem = overviewRowCell.itemViews!.first!

        let sizeAspect = rowDetailsItem.frame.width / overviewItem.frame.width
        return sizeAspect
    }

    private func fetchOverviewVisibleViews(forData data: ChartOverviewToRowDetailsTransitionData) -> [UIView] {
        let overviewVisibleItems: [UIView] = data.overviewController.chartView.visibleCells()
        let overviewVisibleColumnHeaders: [UIView] = data.overviewController.chartView.visibleSupplementaryViewsOfKind(ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier)
        let overviewVisibleCounters: [UIView] = data.overviewController.chartView.visibleSupplementaryViewsOfKind(ChartOverviewCollectionLayout.kRowCounterElementIdentifier)

        var overviewVisibleViews = [UIView]()
        overviewVisibleViews.appendContentsOf(overviewVisibleItems)
        overviewVisibleViews.appendContentsOf(overviewVisibleColumnHeaders)
        overviewVisibleViews.appendContentsOf(overviewVisibleCounters)

        return overviewVisibleViews
    }

    private func calculateOverviewVisibleViewAnchorPoint(forData data: ChartOverviewToRowDetailsTransitionData, view: UIView, andTransitionRowCellFrame frame: CGRect) -> CGPoint {
        let globAnchorPoint = CGPoint(x: frame.midX, y: frame.midY)
        let localAnchorPoint = data.containerView.convertPoint(globAnchorPoint, toView: view)
        let normAnchorPoint = CGPoint(x: localAnchorPoint.x / view.bounds.width, y: localAnchorPoint.y / view.bounds.height)

        return normAnchorPoint
    }

}
