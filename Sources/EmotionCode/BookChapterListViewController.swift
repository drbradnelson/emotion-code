import UIKit

// MARK: Delegate

protocol BookChapterListViewControllerDelegate: class {

    func bookChapterListViewController(bookChapterListViewController: BookChapterListViewController, didSelectChapterAtIndex index: Int)
    func bookChapterListViewControllerDidCancelChapterSelection(bookChapterListViewController: BookChapterListViewController)

}

// MARK: Main

final class BookChapterListViewController: UITableViewController {

    @IBOutlet private var bookChaptersTableView: BookChaptersTableView!

    var bookChapters: [BookChapter] = []
    var selectedChapterIndex = 0
    weak var delegate: BookChapterListViewControllerDelegate?

}

// MARK: Table view data source

extension BookChapterListViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookChapters.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chapter = bookChapters[indexPath.row]
        let cell = bookChaptersTableView.dequeueReusableChapterCellForIndexPath(indexPath)
        cell.setChapterNumber(indexPath.row + 1, chapterTitle: chapter.title)
        if indexPath.row == selectedChapterIndex {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            cell.setChapterSelected(indexPath.row == selectedChapterIndex)
        }
        return cell
    }

}

// MARK: Table view delegate

extension BookChapterListViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChapterTableViewCell else { return }
        selectedChapterIndex = indexPath.row
        tableView.beginUpdates()
        cell.setChapterSelected(true)
        tableView.endUpdates()
        delegate?.bookChapterListViewController(self, didSelectChapterAtIndex: selectedChapterIndex)
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChapterTableViewCell else { return }
        tableView.beginUpdates()
        cell.setChapterSelected(false)
        tableView.endUpdates()
    }

}

// MARK: Navigation bar button actions

private extension BookChapterListViewController {

    @IBAction func userDidTapCancelButton() {
        delegate?.bookChapterListViewControllerDidCancelChapterSelection(self)
    }

}
