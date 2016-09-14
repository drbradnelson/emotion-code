import UIKit

final class BookChapterListViewController: UITableViewController {

    var bookChapters: [Book.Chapter] = []
    var selectedChapterIndex = 0

    // MARK: Table view

    @IBOutlet private var bookChaptersTableView: BookChaptersTableView!

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookChapters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapter = bookChapters[indexPath.row]
        let cell = bookChaptersTableView.dequeueReusableChapterCell(for: indexPath)
        cell.setChapterNumber(indexPath.row + 1)
        cell.setChapterTitle(chapter.title)
        cell.setChapterSelected(indexPath.row == selectedChapterIndex)
        return cell
    }

    // MARK: Table view delegate

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChapterTableViewCell else {
            preconditionFailure()
        }
        cell.setChapterSelected(false)
    }

    // MARK: Storyboard segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bookPageViewController = segue.destination as? BookPageViewController else {
            preconditionFailure()
        }
        prepare(for: bookPageViewController)
    }

    private func prepare(for bookPageViewController: BookPageViewController) {
        guard let selectedChapterIndex = bookChaptersTableView.indexPathForSelectedRow?.row else { return }
        guard bookPageViewController.currentBookChapterViewController.chapterIndex != selectedChapterIndex else { return }
        bookPageViewController.showChapter(at: selectedChapterIndex, direction: .forward, animated: false)
    }

}
