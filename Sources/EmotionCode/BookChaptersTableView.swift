import UIKit

final class BookChaptersTableView: UITableView {

    // MARK: Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        estimatedRowHeight = 44
        rowHeight = UITableViewAutomaticDimension
    }

    // MARK: Dequeing cells

    func dequeueReusableChapterCell(for indexPath: IndexPath) -> ChapterTableViewCell {
        guard let chapterCell = dequeueReusableCell(withIdentifier: ChapterTableViewCell.preferredReuseIdentifier, for: indexPath) as? ChapterTableViewCell else {
            preconditionFailure()
        }
        return chapterCell
    }

}
