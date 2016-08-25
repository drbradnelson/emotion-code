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

// MARK: Accessory type

extension ChapterTableViewCell {

    func setChapterSelected(selected: Bool) {
        accessoryType = selected ? .Checkmark : .None
    }

}

// MARK: Reuse identifier

extension ChapterTableViewCell {

    static var preferredReuseIdentifier: String {
        return "Chapter Cell"
    }

}
