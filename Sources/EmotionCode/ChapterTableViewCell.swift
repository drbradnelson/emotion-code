import UIKit

final class ChapterTableViewCell: UITableViewCell {

    // MARK: Chapter title

    func setChapterTitle(_ title: String) {
        chapterTitleLabel.text = title
    }

    @IBOutlet private var chapterTitleLabel: UILabel!

    // MARK: Chapter subtitle

    func setChapterSubtitle(_ subtitle: String?) {
        chapterSubtitleLabel.isHidden = subtitle == nil
        chapterSubtitleLabel.text = subtitle
    }

    @IBOutlet private var chapterSubtitleLabel: UILabel!

    // MARK: Chapter selection

    func setChapterSelected(_ selected: Bool) {
        accessoryType = selected ? .checkmark : .none
    }

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "Chapter Cell"

}
