import UIKit

// MARK: Main

final class ChapterSelectionTableViewController: UITableViewController {

    var bookChapters: [BookChapter] = []
    var selectedChapterIndex = 0

}

// MARK: View lifecycle

extension ChapterSelectionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

// MARK: Table view data source

extension ChapterSelectionTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookChapters.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(ChapterTableViewCell.preferredReuseIdentifier, forIndexPath: indexPath) as? ChapterTableViewCell else {
            preconditionFailure("Chapter cell not found")
        }
        let chapter = bookChapters[indexPath.row]
        cell.setChapterNumber(String(indexPath.row + 1), chapterTitle: chapter.title)
        cell.accessoryType = indexPath.row == selectedChapterIndex ? .Checkmark : .None
        return cell
    }

}

// MARK: Table view delegate

extension ChapterSelectionTableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousSelectedIndexPath = NSIndexPath(forRow: selectedChapterIndex, inSection: 0)
        let previousSelectedCell = tableView.cellForRowAtIndexPath(previousSelectedIndexPath)
        selectedChapterIndex = indexPath.row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.beginUpdates()
        previousSelectedCell?.accessoryType = .None
        cell?.accessoryType = .Checkmark
        tableView.endUpdates()
    }

}

// MARK: Navigation bar button actions

private extension ChapterSelectionTableViewController {

    @IBAction func userDidTapCancelButton() {
    }

}
