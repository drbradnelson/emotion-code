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
        cell.setChapterNumber(String(indexPath.row + 1), chapterTitle: chapter.title)
        if indexPath.row == selectedChapterIndex {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            cell.accessoryType = indexPath.row == selectedChapterIndex ? .Checkmark : .None
        }
        return cell
    }

}

// MARK: Table view delegate

extension BookChapterListViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedChapterIndex = indexPath.row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.beginUpdates()
        cell?.accessoryType = .Checkmark
        tableView.endUpdates()
        delegate?.bookChapterListViewController(self, didSelectChapterAtIndex: selectedChapterIndex)
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.beginUpdates()
        cell?.accessoryType = .None
        tableView.endUpdates()
    }

}

// MARK: Navigation bar button actions

private extension BookChapterListViewController {

    @IBAction func userDidTapCancelButton() {
        delegate?.bookChapterListViewControllerDidCancelChapterSelection(self)
    }

}
