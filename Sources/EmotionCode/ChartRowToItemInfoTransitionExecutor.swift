import UIKit

extension ChartRowToItemTransition {

    func createTransitionInfo(forRowDetailsCell rowDetailsCell: CollectionViewCellWithTitle, forItemDetailsView itemDetailsView: UIView, forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews) -> ItemTransitionInfo {

        var info = ItemTransitionInfo()

        data.containerView.addSubview(transitionViews.itemTransitionContainer)
        transitionViews.itemTransitionContainer.frame = getRowDetailsItemFrame(forData: data, rowDetailsCell: rowDetailsCell)

        let initialFrame = rowDetailsCell.superview!.convertRect(rowDetailsCell.frame, toView: transitionViews.itemTransitionContainer)
        transitionViews.itemTransitionContainer.frame = getItemDetailsFrame(forData: data, itemDetailsView: itemDetailsView)
        let changeFrame = data.itemDetailsController.itemDetailsView.convertRect(data.itemDetailsController.nameLabel.frame, toView: transitionViews.itemTransitionContainer)

        info.itemDetailsLabelSnapshotFrame = getItemDetailsLabelSnapshotFrame(forData: data, transitionViews: transitionViews)
        info.nameLabelsContainerInitialFrame = initialFrame
        info.nameLabelsContainerChangedFrame = changeFrame
        info.rowDetailsItemFrame = getRowDetailsItemFrame(forData: data, rowDetailsCell: rowDetailsCell)
        info.itemDetailsFrame = getItemDetailsFrame(forData: data, itemDetailsView: itemDetailsView)
        info.itemDetailsNameFrame = rowDetailsViewFrame(forData: data)
        info.rowDetailsItemBackgroundColor = rowDetailsCell.backgroundColor
        info.itemDetailsBackgroundColor = itemDetailsView.backgroundColor

        return info
    }

    func getItemDetailsLabelSnapshotFrame(forData data: ChartRowToItemTransitionData, transitionViews: ItemTransitionViews) -> CGRect {
        return data.itemDetailsController.itemDetailsView.convertRect(data.itemDetailsController.detailsLabel.frame, toView: transitionViews.itemTransitionContainer)
    }

    func getRowDetailsItemFrame(forData data: ChartRowToItemTransitionData, rowDetailsCell: CollectionViewCellWithTitle) -> CGRect {
        return data.rowDetailsController.rowDetailsView.convertRect(rowDetailsCell.frame, toView: data.containerView)
    }

    func getItemDetailsFrame(forData data: ChartRowToItemTransitionData, itemDetailsView: UIView) -> CGRect {
        return data.itemDetailsController.contentView.convertRect(itemDetailsView.frame, toView: data.containerView)
    }

    func rowDetailsViewFrame(forData data: ChartRowToItemTransitionData) -> CGRect {
        return data.rowDetailsController.rowDetailsView.convertRect(data.itemDetailsController.nameLabel.frame, toView: data.rowDetailsController.rowDetailsView)
    }
}
