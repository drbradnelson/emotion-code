import UIKit

final class BookSegueController {

    // MARK: Initialization

    private let bookPageViewController: BookPageViewController

    init(bookPageViewController: BookPageViewController) {
        self.bookPageViewController = bookPageViewController
    }

    // MARK: Segueing

    func prepare(for destinationViewController: UIViewController) {
        guard let navigationController = destinationViewController as? UINavigationController else {
            preconditionFailure()
        }
        prepare(for: navigationController)
    }

    private func prepare(for navigationController: UINavigationController) {
        guard let bookChapterListViewController = navigationController.topViewController as? BookChapterListViewController else {
            preconditionFailure()
        }
        prepare(for: bookChapterListViewController)
    }

    private func prepare(for bookChapterListViewController: BookChapterListViewController) {
        bookChapterListViewController.bookChapters = bookPageViewController.bookController.book.chapters
        bookChapterListViewController.selectedChapterIndex = bookPageViewController.currentBookChapterViewController.chapterIndex
    }

}
