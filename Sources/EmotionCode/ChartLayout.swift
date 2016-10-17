import UIKit

final class ChartLayout: UICollectionViewLayout {

    private let numberOfColumns = 2

    private let itemPadding: CGFloat = 5
    private let sectionPadding: CGFloat = 15

    private var contentHeight: CGFloat = 0

    private var columnWidth: CGFloat {
        return collectionViewContentSize.width / CGFloat(numberOfColumns)
    }

    private var itemSize: CGSize {
        let totalPadding = 2 * sectionPadding
        let width = collectionViewContentSize.width - totalPadding / CGFloat(numberOfColumns)
        let height = 60 / CGFloat(numberOfColumns)

        return CGSize(width: width, height: height)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }

}
