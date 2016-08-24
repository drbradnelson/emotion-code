import UIKit

// MARK: Main

final class BookPageViewController: UIPageViewController {

    @IBOutlet private var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet private var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet private var chapterTitleView: ChapterTitleView!

    private let bookController = BookController()

}

// MARK: View lifecycle

extension BookPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .whiteColor()
        setAccessibilityLabelForNavigationBarButtons()
        showChapterAtIndex(0, direction: .Forward, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentBookChapterViewController.preferredTopLayoutGuide = topLayoutGuide.length
        currentBookChapterViewController.preferredBottomLayoutGuide = bottomLayoutGuide.length
    }

}

private extension BookPageViewController {

    var currentBookChapterViewController: BookChapterViewController {
        guard let chapterViewController = viewControllers?.first as? BookChapterViewController else {
            preconditionFailure("Unable to find chapter view controller")
        }
        return chapterViewController
    }

}

// MARK: Page view controller data source

extension BookPageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let chapterViewController = viewController as? BookChapterViewController where bookController.hasChapter(chapterViewController.chapterIndex - 1) else { return nil }
        let previousChapterViewController = chapterViewControllerWithChapterIndex(chapterViewController.chapterIndex - 1)
        return previousChapterViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let chapterViewController = viewController as? BookChapterViewController where bookController.hasChapter(chapterViewController.chapterIndex + 1) else { return nil }
        let nextChapterViewController = chapterViewControllerWithChapterIndex(chapterViewController.chapterIndex + 1)
        return nextChapterViewController
    }

}

// MARK: Page view controller delegate

extension BookPageViewController: UIPageViewControllerDelegate {

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        chapterTitleView.setChapterIndex(currentBookChapterViewController.chapterIndex)
    }

}

// MARK: Loading chapters

private extension BookPageViewController {

    func chapterViewControllerWithChapterIndex(chapterIndex: Int) -> BookChapterViewController {
        let chapterViewController = BookChapterViewController.instantiateFromStoryboard()
        let chapter = bookController.book.chapters[chapterIndex]
        chapterViewController.chapterURL = chapter.fileURL
        chapterViewController.chapterIndex = chapterIndex
        chapterViewController.preferredTopLayoutGuide = topLayoutGuide.length
        chapterViewController.preferredBottomLayoutGuide = bottomLayoutGuide.length
        return chapterViewController
    }

    func showChapterAtIndex(chapterIndex: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        let chapterViewController = chapterViewControllerWithChapterIndex(chapterIndex)
        chapterTitleView.setChapterIndex(chapterViewController.chapterIndex)
        setViewControllers([chapterViewController], direction: direction, animated: animated, completion: nil)
    }

}

// MARK: Navigation bar buttons accessibility

private extension BookPageViewController {

    func setAccessibilityLabelForNavigationBarButtons() {
        leftBarButtonItem.accessibilityLabel = NSLocalizedString("Previous Chapter", comment: "")
        rightBarButtonItem.accessibilityLabel = NSLocalizedString("Next Chapter", comment: "")
    }

}

// MARK: Navigation bar button actions

private extension BookPageViewController {

    @IBAction func userDidTapLeftBarButtonItem() {
        guard bookController.hasChapter(currentBookChapterViewController.chapterIndex - 1) else { return }
        showChapterAtIndex(currentBookChapterViewController.chapterIndex - 1, direction: .Reverse, animated: true)
    }

    @IBAction func userDidTapRightBarButtonItem() {
        guard bookController.hasChapter(currentBookChapterViewController.chapterIndex + 1) else { return }
        showChapterAtIndex(currentBookChapterViewController.chapterIndex + 1, direction: .Forward, animated: true)
    }

}

// MARK: Storyboard segues

extension BookPageViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let navigationController = segue.destinationViewController as? UINavigationController else {
            preconditionFailure()
        }
        prepareForSegueToNavigationController(navigationController)
    }

}

private extension BookPageViewController {

    func prepareForSegueToNavigationController(navigationController: UINavigationController) {
        guard let chapterSelectionTableViewController = navigationController.topViewController as? ChapterSelectionTableViewController else {
            preconditionFailure()
        }
        chapterSelectionTableViewController.bookChapters = bookController.book.chapters
        chapterSelectionTableViewController.selectedChapterIndex = currentBookChapterViewController.chapterIndex
    }

}
