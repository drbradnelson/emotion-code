import UIKit

protocol ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutCore.Mode

}
