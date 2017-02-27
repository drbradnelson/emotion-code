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

}
