import UIKit

extension UICollectionView {

    var indexPathForSelectedItem: IndexPath? {
        return indexPathsForSelectedItems?.first
    }

    var indexPaths: [IndexPath] {
        let sections = 0..<numberOfSections
        return sections.flatMap(indexPaths)
    }

    func indexPaths(forSection section: Int) -> [IndexPath] {
        let items = 0..<self.numberOfItems(inSection: section)
        return items.map { item in IndexPath(item: item, section: section) }
    }

    var visibleContentHeight: CGFloat {
        return bounds.height - contentInset.top - contentInset.bottom
    }

    var visibleContentSize: CGSize {
        let width = bounds.width - contentInset.left - contentInset.right
        let height = bounds.height - contentInset.top - contentInset.bottom
        return CGSize(width: width, height: height)
    }

}
