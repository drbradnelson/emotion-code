import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var smallTitleLabel: UILabel!
    @IBOutlet var largeTitleLabel: UILabel!

    @IBInspectable var oddRowColor: UIColor!
    @IBInspectable var evenRowColor: UIColor!

    static let preferredReuseIdentifier = "ItemCell"

    func configure(with emotion: Chart.Emotion) {
        smallTitleLabel.text = emotion.title
        largeTitleLabel.text = emotion.title
    }

    func setBackgroundColor(for indexPath: IndexPath) {
        let row = indexPath.section / ChartLayout.numberOfColumns + 1
        let isRowEven = (row % ChartLayout.numberOfColumns == 0)
        backgroundColor = isRowEven ? evenRowColor : oddRowColor
    }

}
