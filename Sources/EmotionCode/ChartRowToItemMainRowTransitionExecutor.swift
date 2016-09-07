import UIKit

extension ChartRowToItemTransition {

    struct ItemTransitionInfo {
        init() {}

        var rowDetailsItemFrame: CGRect!
        var itemDetailsFrame: CGRect!
        var itemDetailsNameFrame: CGRect!
        var nameLabelsContainerInitialFrame: CGRect!
        var nameLabelsContainerChangedFrame: CGRect!
        var rowDetailsItemBackgroundColor: UIColor!
        var itemDetailsBackgroundColor: UIColor!
        var itemDetailsLabelSnapshotFrame: CGRect!
    }

    struct ItemTransitionViews {
        init() {}

        var itemTransitionContainer: UIView!
        var rowDetailsItemTransitionView: UIView!
        var itemDetailsNameTransitionView: UIView!
        var nameLabelsContainer: UIView!
        var itemDetailsLabelSnapshotView: UIView!
    }

    func createItemViewTransition(forData data: ChartRowToItemTransitionData) -> TransitionExecutor {

        let itemIndexPath = NSIndexPath(forItem: data.itemDetailsController.itemPosition.itemIndex, inSection: 0)

        let rowDetailsItemCell = data.rowDetailsController.rowDetailsView.cellForItemAtIndexPath(itemIndexPath) as! CollectionViewCellWithTitle

        let itemDetailsView = data.itemDetailsController.itemDetailsView

        let views = self.createTransitionViews(forRowDetailsCell: rowDetailsItemCell, forData: data)
        let info = self.createTransitionInfo(forRowDetailsCell: rowDetailsItemCell, forItemDetailsView: itemDetailsView, forData: data, transitionViews: views)

        return self.createItemViewExecutor(forData: data, forItemTransitionViews: views, andTransitionInfo: info)
    }

}

// MARK: Helper methods

private extension ChartRowToItemTransition {

    func createItemViewExecutor(forData data: ChartRowToItemTransitionData, forItemTransitionViews transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) -> TransitionExecutor {

        let prepareBlock = {
            self.prepareAllTransitionViews(forData: data, forItemTransitionViews: transitionViews, andTransitionInfo: info)
            data.rowDetailsController.rowDetailsView.alpha = self.value(data, forward: 1.0, back: 0.0)
        }

        let executionBlock = {
            transitionViews.itemTransitionContainer.frame = self.value(data, forward: info.itemDetailsFrame, back: info.rowDetailsItemFrame)
            transitionViews.nameLabelsContainer.frame = self.value(data, forward: info.nameLabelsContainerChangedFrame, back: info.nameLabelsContainerInitialFrame)
            transitionViews.rowDetailsItemTransitionView.alpha = self.value(data, forward: 0.0, back: 1.0)
            transitionViews.itemDetailsNameTransitionView.alpha = self.value(data, forward: 1.0, back: 0.0)
            data.rowDetailsController.rowDetailsView.alpha = self.value(data, forward: 0.0, back: 1.0)
            data.rowDetailsController.chartRowTitleLabel.alpha = self.value(data, forward: 0.0, back: 1.0)
        }

        let completionBlock = { (canceled: Bool) in
            data.rowDetailsController.rowDetailsView.alpha = 1.0
            data.rowDetailsController.chartRowTitleLabel.alpha = 1.0
            transitionViews.itemTransitionContainer.removeFromSuperview()
        }

        return TransitionExecutorFactory.transitionExecutor(withPrepareBlock: prepareBlock, executeBlock: executionBlock, completionBlock: completionBlock)
    }

    func prepareAllTransitionViews(forData data: ChartRowToItemTransitionData, forItemTransitionViews transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {
        self.prepareTransitionContainerView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
        self.prepareItemDetailsDescriptionTransitionView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
        self.prepareNameLabelsContainerView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
        self.prepareRowDetailsItemTransitionView(forData: data, transitionViews: transitionViews, andTransitionInfo:info)
        self.prepareItemDetailsNameTransitionView(forData: data, transitionViews: transitionViews, andTransitionInfo: info)
    }


    func prepareTransitionContainerView(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        data.containerView.addSubview(transitionViews.itemTransitionContainer)
        transitionViews.itemTransitionContainer.frame = self.value(data, forward: info.rowDetailsItemFrame, back: info.itemDetailsFrame)

    }


    func prepareNameLabelsContainerView(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        transitionViews.nameLabelsContainer.frame = self.value(data, forward: info.nameLabelsContainerInitialFrame, back: info.nameLabelsContainerChangedFrame)
        transitionViews.itemTransitionContainer.backgroundColor = info.itemDetailsBackgroundColor

    }

    func prepareRowDetailsItemTransitionView(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        let centerFrame = transitionViews.nameLabelsContainer.frame
        transitionViews.rowDetailsItemTransitionView.center = CGPoint(x: centerFrame.width / 2, y: centerFrame.height / 2)
        transitionViews.rowDetailsItemTransitionView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]

        transitionViews.rowDetailsItemTransitionView.alpha = self.value(data, forward: 1.0, back: 0.0)

    }

    func prepareItemDetailsNameTransitionView(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {

        let centerFrame = transitionViews.nameLabelsContainer.frame
        transitionViews.itemDetailsNameTransitionView.center = CGPoint(x: centerFrame.width / 2, y: centerFrame.height / 2)
        transitionViews.itemDetailsNameTransitionView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]

        transitionViews.itemDetailsNameTransitionView.alpha = self.value(data, forward: 0.0, back: 1.0)
    }

    func prepareItemDetailsDescriptionTransitionView(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews, andTransitionInfo info: ItemTransitionInfo) {
        transitionViews.itemDetailsLabelSnapshotView.frame = info.itemDetailsLabelSnapshotFrame
    }

    func createTransitionViews(forRowDetailsCell rowDetailsCell: CollectionViewCellWithTitle, forData data: ChartRowToItemTransitionData) -> ItemTransitionViews {

        var transitionViews = ItemTransitionViews()

        transitionViews.itemTransitionContainer = UIView()
        transitionViews.itemTransitionContainer.clipsToBounds = true

        transitionViews.itemDetailsNameTransitionView = data.itemDetailsController.nameLabel.snapshotViewAfterScreenUpdates(self.value(data, forward: true, back: false))
        transitionViews.rowDetailsItemTransitionView = rowDetailsCell.snapshotViewAfterScreenUpdates(self.value(data, forward: false, back: true))

        transitionViews.nameLabelsContainer = UIView()
        transitionViews.nameLabelsContainer.clipsToBounds = true
        transitionViews.nameLabelsContainer.addSubview(transitionViews.itemDetailsNameTransitionView)
        transitionViews.nameLabelsContainer.addSubview(transitionViews.rowDetailsItemTransitionView)

        transitionViews.itemTransitionContainer.addSubview(transitionViews.nameLabelsContainer)

        transitionViews.itemDetailsLabelSnapshotView = data.itemDetailsController.detailsLabel.snapshotViewAfterScreenUpdates(true)
        transitionViews.itemTransitionContainer.addSubview(transitionViews.itemDetailsLabelSnapshotView)

        return transitionViews

    }

}
