import UIKit

// MARK: Main

final class BookChaptersTableView: UITableView {}

// MARK: Initialization

extension BookChaptersTableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        estimatedRowHeight = 44
        rowHeight = UITableViewAutomaticDimension
    }

}

// MARK: Dequeing cells

extension BookChaptersTableView {

    func dequeueReusableChapterCellForIndexPath(indexPath: NSIndexPath) -> ChapterTableViewCell {
        guard let chapterCell = dequeueReusableCellWithIdentifier(ChapterTableViewCell.preferredReuseIdentifier, forIndexPath: indexPath) as? ChapterTableViewCell else {
            preconditionFailure("Chapter cell not found")
        }
        return chapterCell
    }

}
