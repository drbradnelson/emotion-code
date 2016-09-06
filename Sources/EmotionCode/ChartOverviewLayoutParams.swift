import UIKit

protocol ChartOverviewLayoutParams {
    var widthForRowCounterElement: CGFloat {get}
    var heightForColumnHeaderElement: CGFloat {get}
    var spacingBetweenColumns: CGFloat {get}
    var spacingBetweenRows: CGFloat {get}
    var availableWidth: CGFloat {get}
    var contentInsets: UIEdgeInsets {get}

    func heightForRowElement(forRow row: Int) -> CGFloat
}

extension ChartOverviewCollectionLayout: ChartOverviewLayoutParams {
    var widthForRowCounterElement: CGFloat {
        get {
            return delegate.widthForRowCounterElement(inCollectionView: collectionView!, layout: self)
        }
    }

    var heightForColumnHeaderElement: CGFloat {
        get {
            return delegate.heightForColumnHeaderElement(inCollectionView: collectionView!, layout: self)
        }
    }

    var spacingBetweenColumns: CGFloat {
        get {
            return delegate.spacingBetweenColumns(inCollectionView: collectionView!, layout: self)
        }
    }

    var spacingBetweenRows: CGFloat {
        get {
            return delegate.spacingBetweenRows(inCollectionView: collectionView!, layout: self)
        }
    }

    var availableWidth: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }

    func heightForRowElement(forRow row: Int) -> CGFloat {
        return delegate.heightForRowElement(inCollectionView: collectionView!, layout: self, forRow: row)
    }

    var layoutParams: ChartOverviewLayoutParams {
        get {
            return self
        }
    }

    var contentInsets: UIEdgeInsets {
        get {
            return delegate.insetsForContent(inCollectionView: collectionView!, layout: self)
        }
    }
}