import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView!

    static let preferredReuseIdentifier = "ItemCell"

    private static let oddRowColor = UIColor(red: 0.56, green: 0.78, blue: 0.78, alpha: 1)
    private static let evenRowColor = UIColor(red: 0.66, green: 0.88, blue: 0.98, alpha: 1)

    func configure(with emotion: Chart.Emotion) {
        titleLabel.text = emotion.title
        descriptionTextView.text = emotion.description
    }

    func setBackgroundColor(for indexPath: IndexPath) {
        let row = (indexPath.section + ChartLayout.numberOfColumns) / ChartLayout.numberOfColumns
        let isRowEven = (row % ChartLayout.numberOfColumns == 0)
        backgroundColor = isRowEven ? ItemCollectionViewCell.evenRowColor : ItemCollectionViewCell.oddRowColor
    }

    func setDescriptionVisible(_ visible: Bool) {
        titleLabel.alpha = visible ? 0 : 1
        descriptionTextView.alpha = visible ? 1 : 0
    }

}
