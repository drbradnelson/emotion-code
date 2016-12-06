import UIKit
import ChartLayout

protocol ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutMode

}
