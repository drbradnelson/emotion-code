import UIKit

// MARK: Main

final class BookPageViewController: UIPageViewController {

    @IBOutlet private var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet private var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet private var navigationBarTitleButton: UIButton!
    private let bookController = BookController()

}

// MARK: View lifecycle

extension BookPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor.whiteColor()
        setAccessibilityLabelForNavigationBarButtons()
        showChapterAtIndex(0, direction: .Forward, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let chapterViewController = viewControllers?.first as? BookChapterViewController else { return }
        chapterViewController.preferredTopLayoutGuide = topLayoutGuide.length
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

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        guard let nextChapterViewController = pendingViewControllers.first as? BookChapterViewController else { return }
        setNavigationBarTitleButtonTitleForChapterAtIndex(nextChapterViewController.chapterIndex)
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
        return chapterViewController
    }

    func showChapterAtIndex(chapterIndex: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        let chapterViewController = chapterViewControllerWithChapterIndex(chapterIndex)
        setNavigationBarTitleButtonTitleForChapterAtIndex(chapterIndex)
        setViewControllers([chapterViewController], direction: direction, animated: animated, completion: nil)
    }

}

// MARK: Navigation bar title

private extension BookPageViewController {

    func setNavigationBarTitleButtonTitleForChapterAtIndex(chapterIndex: Int) {
        navigationBarTitleButton.setTitle("Chapter \(chapterIndex + 1) ▼", forState: .Normal)
        navigationBarTitleButton.accessibilityLabel = "Chapter \(chapterIndex + 1)"
        navigationBarTitleButton.sizeToFit()
    }

}

// MARK: Navigation bar buttons accessibility

private extension BookPageViewController {

    func setAccessibilityLabelForNavigationBarButtons() {
        leftBarButtonItem.accessibilityLabel = "Previous Chapter"
        rightBarButtonItem.accessibilityLabel = "Next Chapter"
    }

}

// MARK: Navigation bar button actions

private extension BookPageViewController {

    @objc func userDidTapNavigationBarTitleButton() {}

    @IBAction func userDidTapLeftBarButtonItem() {
        guard let chapterViewController = viewControllers?.first as? BookChapterViewController where bookController.hasChapter(chapterViewController.chapterIndex - 1) else { return }
        showChapterAtIndex(chapterViewController.chapterIndex - 1, direction: .Reverse, animated: true)
    }

    @IBAction func userDidTapRightBarButtonItem() {
        guard let chapterViewController = viewControllers?.first as? BookChapterViewController where bookController.hasChapter(chapterViewController.chapterIndex + 1) else { return }
        showChapterAtIndex(chapterViewController.chapterIndex + 1, direction: .Forward, animated: true)
    }

}
