import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "ItemCell"

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        smallTitleLabel.frame = contentView.bounds
        largeTitleLabel.frame = contentView.bounds
        emotionDescriptionView?.frame = contentView.bounds
    }

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
        let row = indexPath.section / 2 + 1
        let isRowEven = (row % 2 == 0)
        let color = isRowEven ? evenRowColor : oddRowColor
        contentView.backgroundColor = color
        smallTitleLabel.backgroundColor = color
        largeTitleLabel.backgroundColor = color
    }

    // MARK: Emotion description text view

    private var emotionDescriptionView: UITextView? {
        let textViews = contentView.subviews.flatMap { $0 as? UITextView }
        precondition(textViews.count <= 1)
        return textViews.first
    }

    func addEmotionDescriptionView(withDescription description: String) {
        let emotionDescriptionView = UITextView(frame: contentView.bounds)
        emotionDescriptionView.isOpaque = true
        emotionDescriptionView.alpha = 0
        emotionDescriptionView.backgroundColor = contentView.backgroundColor
        emotionDescriptionView.font = .preferredFont(forTextStyle: .body)
        emotionDescriptionView.textAlignment = .center
        emotionDescriptionView.isEditable = false
        emotionDescriptionView.text = description
        contentView.addSubview(emotionDescriptionView)
    }

    func removeEmotionDescriptionView() {
        emotionDescriptionView!.removeFromSuperview()
    }

    func setEmotionDescriptionVisible(_ descriptionVisible: Bool) {
        emotionDescriptionView!.alpha = descriptionVisible ? 1 : 0
    }

}
