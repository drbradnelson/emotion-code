import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    static let reuseIdentifier = "ItemCell"

    func configure(title: String) {
        titleLabel.text = title
    }

}
