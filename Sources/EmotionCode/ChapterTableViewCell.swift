import UIKit

final class ChapterTableViewCell: UITableViewCell {

    // MARK: Chapter number

    func setChapterNumber(_ number: Int) {
        chapterNumberLabel.text = ChapterTableViewCell.numberFormatter.string(from: number as NSNumber)
    }

    @IBOutlet private var chapterNumberLabel: UILabel!
    private static let numberFormatter = NumberFormatter()

    // MARK: Chapter title

    func setChapterTitle(_ title: String) {
        chapterTitleLabel.text = title
    }

    @IBOutlet private var chapterTitleLabel: UILabel!

    // MARK: Chapter selection

    func setChapterSelected(_ selected: Bool) {
        accessoryType = selected ? .checkmark : .none
    }

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "Chapter Cell"

}
