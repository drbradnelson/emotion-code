import UIKit

extension UICollectionView {

    var indexPathForSelectedItem: IndexPath? {
        return indexPathsForSelectedItems?.first
    }

}
