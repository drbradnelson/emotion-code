import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    @IBInspectable private var oddRowColor: UIColor!
    @IBInspectable private var evenRowColor: UIColor!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(with emotion: Chart.Emotion) {
        titleLabel.text = emotion.title
        descriptionTextView.text = emotion.description
    }

    func setBackgroundColor(for indexPath: IndexPath) {
        let row = (indexPath.section + ChartLayout.numberOfColumns) / ChartLayout.numberOfColumns
        let isRowEven = (row % ChartLayout.numberOfColumns == 0)
        backgroundColor = isRowEven ? evenRowColor : oddRowColor
    }

    func setDescriptionVisible(_ visible: Bool) {
        titleLabel.alpha = visible ? 0 : 1
        descriptionTextView.alpha = visible ? 1 : 0
    }

}
