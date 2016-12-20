import UIKit
import ChartLayoutCalculator

protocol ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutMode

}
