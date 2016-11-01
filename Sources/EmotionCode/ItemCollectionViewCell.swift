import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(item: Chart.Item) {
        titleLabel.text = item.title
        descriptionTextView.text = item.description
    }

    func showTitle() {
        UIView.animate(withDuration: 0.4) {
            self.titleLabel.alpha = 1
            self.descriptionTextView.alpha = 0
        }
    }

    func showDescription() {
        self.titleLabel.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.descriptionTextView.alpha = 1
        }
    }

}
