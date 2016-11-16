import UIKit

extension UICollectionViewController {

    func layoutCellsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView?.visibleCells.forEach { $0.layoutIfNeeded() }
        }, completion: nil)
    }

    func layoutSupplementaryViewsAlongsideTransition(kinds: [String]) {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            guard let collectionView = collectionView else { return }
            let supplementaryViews = kinds.flatMap(collectionView.visibleSupplementaryViews)
            supplementaryViews.forEach { $0.layoutIfNeeded() }
        }, completion: nil)
    }

}
