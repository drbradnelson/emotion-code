import UIKit

// MARK: Main

final class BookSegueController {

    private let bookPageViewController: BookPageViewController

    init(bookPageViewController: BookPageViewController) {
        self.bookPageViewController = bookPageViewController
    }

}

extension BookSegueController {

    func prepareForSegueToDestinationViewController(destinationViewController: UIViewController) {
        guard let navigationController = destinationViewController as? UINavigationController else {
            preconditionFailure()
        }
        prepareForSegueToNavigationController(navigationController)
    }

}

private extension BookSegueController {

    func prepareForSegueToNavigationController(navigationController: UINavigationController) {
        guard let chapterSelectionTableViewController = navigationController.topViewController as? ChapterSelectionTableViewController else {
            preconditionFailure()
        }
        chapterSelectionTableViewController.bookChapters = bookPageViewController.bookController.book.chapters
        chapterSelectionTableViewController.selectedChapterIndex = bookPageViewController.currentBookChapterViewController.chapterIndex
        chapterSelectionTableViewController.delegate = bookPageViewController
    }

}
