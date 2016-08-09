import UIKit

// MARK: Main

class ChartFlowLayout: UICollectionViewFlowLayout {

    let proportionalRatio: CGFloat = 5
    let numberOfColumns: CGFloat = 2

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

}

// MARK: Layout

extension ChartFlowLayout {

    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 5
        scrollDirection = .Vertical
    }

    func itemWidth() -> CGFloat {
        return ((collectionView!.frame).width / numberOfColumns) - 1
    }

    func itemHeight() -> CGFloat {
        return itemWidth() / proportionalRatio
    }

    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight())
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight())
        }
    }

}
