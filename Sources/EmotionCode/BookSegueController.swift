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
        guard let bookChapterListViewController = navigationController.topViewController as? BookChapterListViewController else {
            preconditionFailure()
        }
        prepareForSegueToBookChapterListViewController(bookChapterListViewController)
    }

    func prepareForSegueToBookChapterListViewController(bookChapterListViewController: BookChapterListViewController) {
        bookChapterListViewController.bookChapters = bookPageViewController.bookController.book.chapters
        bookChapterListViewController.selectedChapterIndex = bookPageViewController.currentBookChapterViewController.chapterIndex
    }

}
