import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "ItemCell"

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateEmotionDescriptionFrame()
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
        backgroundColor = isRowEven ? evenRowColor : oddRowColor
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
        emotionDescriptionView.backgroundColor = backgroundColor
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

    func updateEmotionDescriptionFrame() {
        emotionDescriptionView?.frame = contentView.bounds
    }

}
