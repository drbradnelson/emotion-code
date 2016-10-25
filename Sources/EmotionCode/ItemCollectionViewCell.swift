import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(title: String) {
        titleLabel.text = title
    }

    func configure(item: Chart.Item) {
        titleLabel.text = item.title
        descriptionTextView.text = item.description
    }

}
