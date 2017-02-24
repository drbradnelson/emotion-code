import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "ItemCell"

    // MARK: Title labels

    @IBOutlet var smallTitleLabel: UILabel!
    @IBOutlet var largeTitleLabel: UILabel!

    func configure(with emotion: Chart.Emotion) {
        smallTitleLabel.text = emotion.title
        largeTitleLabel.text = emotion.title
    }

    // MARK: Background color

    @IBInspectable var oddRowColor: UIColor!
    @IBInspectable var evenRowColor: UIColor!

    func setBackgroundColor(for indexPath: IndexPath) {
        let row = indexPath.section / ChartLayout.numberOfColumns + 1
        let isRowEven = (row % ChartLayout.numberOfColumns == 0)
        backgroundColor = isRowEven ? evenRowColor : oddRowColor
    }

    // MARK: Emotion description text view

    private var emotionDescriptionView: UITextView!

    func addEmotionDescriptionView(text: String) {
        guard emotionDescriptionView == nil else { return }
        emotionDescriptionView = UITextView(frame: bounds)
        emotionDescriptionView.isOpaque = true
        emotionDescriptionView.alpha = 0
        emotionDescriptionView.backgroundColor = backgroundColor
        emotionDescriptionView.font = .preferredFont(forTextStyle: .body)
        emotionDescriptionView.textAlignment = .center
        emotionDescriptionView.isEditable = false
        emotionDescriptionView.text = text
        addSubview(emotionDescriptionView)
    }

    func removeEmotionDescriptionView() {
        guard emotionDescriptionView != nil else { return }
        emotionDescriptionView.removeFromSuperview()
        emotionDescriptionView = nil
    }

    func setEmotionDescriptionVisible(_ descriptionVisible: Bool) {
        emotionDescriptionView.alpha = descriptionVisible ? 1 : 0
    }

    func updateEmotionDescriptionFrame() {
        emotionDescriptionView.frame = bounds
    }

}
