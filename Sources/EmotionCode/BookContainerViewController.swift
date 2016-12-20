import UIKit

final class BookContainerViewController: UIViewController {

    private var bookPageViewController: BookPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = bookPageViewController.previousChapterButtonItem
        navigationItem.titleView = bookPageViewController.chapterTitleView
        navigationItem.rightBarButtonItem = bookPageViewController.nextChapterButtonItem
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bookPageViewController.preferredTopLayoutGuide = topLayoutGuide.length
        bookPageViewController.preferredBottomLayoutGuide = bottomLayoutGuide.length
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let bookPageViewController = segue.destination as? BookPageViewController {
            self.bookPageViewController = bookPageViewController
        }
    }

}
