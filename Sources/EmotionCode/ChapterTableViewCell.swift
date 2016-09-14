import UIKit

// MARK: Main

final class ChapterTableViewCell: UITableViewCell {

    // MARK: Populating with location

    @IBOutlet private var chapterNumberLabel: UILabel!
    @IBOutlet private var chapterTitleLabel: UILabel!

    func setChapterNumber(_ chapterNumber: Int, chapterTitle: String) {
        chapterNumberLabel.text = ChapterTableViewCell.numberFormatter.string(from: chapterNumber as NSNumber)
        chapterTitleLabel.text = chapterTitle
    }

    private static let numberFormatter = NumberFormatter()

    // MARK: Accessory type

    func setChapterSelected(_ selected: Bool) {
        accessoryType = selected ? .checkmark : .none
    }

    // MARK: Reuse identifier

    static let preferredReuseIdentifier = "Chapter Cell"

}
