import UIKit

// MARK: Main

class ChartFlowLayout: UICollectionViewFlowLayout {

    let itemHeight: CGFloat = 36
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

    // swiftlint:disable legacy_cggeometry_functions
    func itemWidth() -> CGFloat {
        return (CGRectGetWidth(collectionView!.frame) / numberOfColumns) - 1
    }
    // swiftlint:disable legacy_constructor
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSizeMake(itemWidth(), itemHeight)
        }
        get {
            return CGSizeMake(itemWidth(), itemHeight)
        }
    }

}
