import UIKit

// MARK: Main

final class BookChapterListViewController: UITableViewController {

    @IBOutlet private var bookChaptersTableView: BookChaptersTableView!

    var bookChapters: [BookChapter] = []
    var selectedChapterIndex = 0

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
        cell.setChapterSelected(indexPath.row == selectedChapterIndex)
        return cell
    }

}

// MARK: Table view delegate

extension BookChapterListViewController {

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChapterTableViewCell else {
            preconditionFailure()
        }
        cell.setChapterSelected(false)
    }

}

// MARK: Storyboard segues

extension BookChapterListViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let bookPageViewConrtoller = segue.destinationViewController as? BookPageViewController else {
            preconditionFailure()
        }
        guard let selectedChapterIndex = bookChaptersTableView.indexPathForSelectedRow?.row else { return }
        if bookPageViewConrtoller.currentBookChapterViewController.chapterURL != selectedChapterIndex {
            bookPageViewConrtoller.showChapterAtIndex(selectedChapterIndex, direction: .Forward, animated: false)
        }
    }

}
