import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(with emotion: Chart.Emotion) {
        titleLabel.text = emotion.title
        descriptionTextView.text = emotion.description
    }

    func setDescriptionVisible(_ visible: Bool) {
        titleLabel.alpha = visible ? 0 : 1
        descriptionTextView.alpha = visible ? 1 : 0
    }

}
