import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(item: Chart.Item) {
        titleLabel.text = item.title
        descriptionTextView.text = item.description
    }

    func toggle() {
        let alpha = titleLabel.alpha
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = abs(alpha - 1)
            self.descriptionTextView.alpha = alpha
        }
    }

}
