import UIKit

// MARK: Main

final class ChapterTableViewCell: UITableViewCell {

    @IBOutlet private var chapterNumberLabel: UILabel!
    @IBOutlet private var chapterTitleLabel: UILabel!

}

// MARK: Populating with location

extension ChapterTableViewCell {

    func setChapterNumber(chapterNumber: String, chapterTitle: String) {
        chapterNumberLabel.text = chapterNumber
        chapterTitleLabel.text = chapterTitle
    }

}

// MARK: Reuse identifier

extension ChapterTableViewCell {

    static var preferredReuseIdentifier: String {
        return "Chapter Cell"
    }

}
