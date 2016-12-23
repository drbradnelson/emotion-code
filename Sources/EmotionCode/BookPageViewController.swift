import UIKit

final class BookPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0

    @IBOutlet private(set) var previousChapterButtonItem: UIBarButtonItem! {
        didSet {
            previousChapterButtonItem.accessibilityLabel = NSLocalizedString("Previous Chapter", comment: "")
        }
    }

    @IBOutlet private(set) var nextChapterButtonItem: UIBarButtonItem! {
        didSet {
            nextChapterButtonItem.accessibilityLabel = NSLocalizedString("Next Chapter", comment: "")
        }
    }

    @IBOutlet private(set) var chapterTitleView: ChapterTitleView!

    let bookController = BookController()
    private lazy var bookSegueController: BookSegueController = BookSegueController(bookPageViewController: self)

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        showChapter(at: 0, direction: .forward, animated: false)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentBookChapterViewController.preferredTopLayoutGuide = preferredTopLayoutGuide
        currentBookChapterViewController.preferredBottomLayoutGuide = preferredTopLayoutGuide
    }

    // MARK: Page view controller data source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let bookChapterViewController = viewController as? BookChapterViewController, bookController.hasChapter(at: bookChapterViewController.chapterIndex - 1) else { return nil }
        return chapterViewControllerWithChapter(at: bookChapterViewController.chapterIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let bookChapterViewController = viewController as? BookChapterViewController, bookController.hasChapter(at: bookChapterViewController.chapterIndex + 1) else { return nil }
        return chapterViewControllerWithChapter(at: bookChapterViewController.chapterIndex + 1)
    }

    // MARK: Page view controller delegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let chapterIndex = currentBookChapterViewController.chapterIndex
        chapterTitleView.setChapterIndex(chapterIndex)
        enableDisablePreviousNextChapterButtons()
    }

    // MARK: Chapter view controller

    var currentBookChapterViewController: BookChapterViewController {
        guard let chapterViewController = viewControllers?.first as? BookChapterViewController else {
            preconditionFailure()
        }
        return chapterViewController
    }

    private func chapterViewControllerWithChapter(at chapterIndex: Int) -> BookChapterViewController {
        let chapterViewController = BookChapterViewController.instantiateFromStoryboard()
        let chapter = bookController.book.chapters[chapterIndex]
        chapterViewController.chapterURL = chapter.fileURL
        chapterViewController.chapterIndex = chapterIndex
        chapterViewController.preferredTopLayoutGuide = preferredTopLayoutGuide
        chapterViewController.preferredBottomLayoutGuide = preferredTopLayoutGuide
        return chapterViewController
    }

    // MARK: ???

    func showChapter(at chapterIndex: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        let chapterViewController = chapterViewControllerWithChapter(at: chapterIndex)
        chapterTitleView.setChapterIndex(chapterViewController.chapterIndex)
        setViewControllers([chapterViewController], direction: direction, animated: animated, completion: nil)
        enableDisablePreviousNextChapterButtons()
    }

    // MARK: Update bar button items

    private func enableDisablePreviousNextChapterButtons() {
        let currentChapterIndex = currentBookChapterViewController.chapterIndex
        previousChapterButtonItem.isEnabled = bookController.hasChapter(at: currentChapterIndex - 1)
        nextChapterButtonItem.isEnabled = bookController.hasChapter(at: currentChapterIndex + 1)
    }

    // MARK: Navigation bar button actions

    @IBAction func userDidTapPreviousChapterButton() {
        guard bookController.hasChapter(at: currentBookChapterViewController.chapterIndex - 1) else { return }
        showChapter(at: currentBookChapterViewController.chapterIndex - 1, direction: .reverse, animated: true)
    }

    @IBAction func userDidTapNextChapterButton() {
        guard bookController.hasChapter(at: currentBookChapterViewController.chapterIndex + 1) else { return }
        showChapter(at: currentBookChapterViewController.chapterIndex + 1, direction: .forward, animated: true)
    }

    // MARK: Storyboard segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        bookSegueController.prepare(for: segue.destination)
    }

    @IBAction func unwindToBookPageViewController(_ segue: UIStoryboardSegue) {}

}
