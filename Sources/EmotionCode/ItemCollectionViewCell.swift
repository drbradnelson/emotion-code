import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "ItemCell"

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.center = contentView.center
    }

    // MARK: Title labels

    @IBOutlet private var titleLabel: UILabel!

    func configure(with emotion: Chart.Emotion) {
        titleLabel.text = emotion.title
    }

    func setTitleLabelSize(to size: CGSize) {
        titleLabel.bounds.size = size
    }

    func shrinkTitleLabel() {
        let widthScale = bounds.width / titleLabel.intrinsicContentSize.width
        let heightScale = bounds.height / titleLabel.intrinsicContentSize.height
        let scale = min(widthScale, heightScale)
        titleLabel.transform = (scale < 1) ? .init(scaleX: scale, y: scale) : .identity
    }

    func enlargeTitleLabel() {
        titleLabel.transform = .identity
    }

    // MARK: Background color

    @IBInspectable var oddRowColor: UIColor!
    @IBInspectable var evenRowColor: UIColor!

    func setColors(for indexPath: IndexPath) {
        let row = indexPath.section / 2 + 1
        let isRowEven = (row % 2 == 0)
        backgroundColor = isRowEven ? evenRowColor : oddRowColor
        titleLabel.textColor = isRowEven ? .black : .white
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
        emotionDescriptionView.textColor = titleLabel.textColor
        emotionDescriptionView.font = .preferredFont(forTextStyle: .body)
        emotionDescriptionView.textAlignment = .center
        emotionDescriptionView.isEditable = false
        emotionDescriptionView.text = description
        contentView.addSubview(emotionDescriptionView)
    }

    func removeEmotionDescriptionView() {
        emotionDescriptionView?.removeFromSuperview()
    }

    func setEmotionDescriptionVisible(_ descriptionVisible: Bool) {
        emotionDescriptionView?.alpha = descriptionVisible ? 1 : 0
        titleLabel.alpha = descriptionVisible ? 0 : 1
    }

    func layoutEmotionDescriptionView() {
        emotionDescriptionView?.frame = contentView.bounds
    }

}
