import UIKit

extension UICollectionViewController {

    func layoutCellsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView?.visibleCells.forEach { $0.layoutIfNeeded() }
            }, completion: nil)
    }

}
