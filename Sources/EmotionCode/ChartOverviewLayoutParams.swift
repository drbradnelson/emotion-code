import UIKit

protocol ChartOverviewLayoutParams {

    var widthForRowCounterElement: CGFloat { get }
    var heightForColumnHeaderElement: CGFloat { get }
    var spacingBetweenColumns: CGFloat { get }
    var spacingBetweenRows: CGFloat { get }
    var availableWidth: CGFloat { get }
    var contentInsets: UIEdgeInsets { get }

    func heightForRowElement(forRow row: Int) -> CGFloat

}

extension ChartOverviewCollectionLayout: ChartOverviewLayoutParams {

    var widthForRowCounterElement: CGFloat {
        return delegate.widthForRowCounterElement(inCollectionView: collectionView!, layout: self)
    }

    var heightForColumnHeaderElement: CGFloat {
        return delegate.heightForColumnHeaderElement(inCollectionView: collectionView!, layout: self)
    }

    var spacingBetweenColumns: CGFloat {
        return delegate.spacingBetweenColumns(inCollectionView: collectionView!, layout: self)
    }

    var spacingBetweenRows: CGFloat {
        return delegate.spacingBetweenRows(inCollectionView: collectionView!, layout: self)
    }

    var availableWidth: CGFloat {
        return collectionView!.bounds.width
    }

    func heightForRowElement(forRow row: Int) -> CGFloat {
        return delegate.heightForRowElement(inCollectionView: collectionView!, layout: self, forRow: row)
    }

    var layoutParams: ChartOverviewLayoutParams {
        return self
    }

    var contentInsets: UIEdgeInsets {
        return delegate.insetsForContent(inCollectionView: collectionView!, layout: self)
    }

}
