import UIKit

extension UICollectionViewController {

    func layoutCellsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { $0.layoutIfNeeded() }
        }, completion: nil)
    }

    func layoutSupplementaryViewsAlongsideTransition(withKinds kinds: [String]) {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            let supplementaryViews = kinds.flatMap(collectionView!.visibleSupplementaryViews)
            supplementaryViews.forEach { $0.layoutIfNeeded() }
        }, completion: nil)
    }

}
