import UIKit

// MARK: Main

final class BookViewController: UIViewController {

    @IBOutlet private var webView: UIWebView!
    private var navigationBarTitleButton: UIButton!
    private let bookController = BookController()
    private var currentBookChapterIndex = 0

}

// MARK: View lifecycle

extension BookViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonForNavigationBarTitle()
        loadChapter(0)
    }

}

private extension BookViewController {

    func loadChapter(chapterIndex: Int) {
        let chapter = bookController.book.chapters[chapterIndex]
        let request = NSURLRequest(URL: chapter.fileURL)
        webView.loadRequest(request)
        currentBookChapterIndex = chapterIndex
        setNavigationBarTitleButtonTitle()
    }

    func loadNextChapter() {
        guard currentBookChapterIndex < bookController.book.chapters.count - 1 else { return }
        loadChapter(currentBookChapterIndex + 1)
    }

    func loadPreviousChapter() {
        guard currentBookChapterIndex > 0 else { return }
        loadChapter(currentBookChapterIndex - 1)
    }

}

// MARK: Navigation bar title

private extension BookViewController {

    func createButtonForNavigationBarTitle() {
        navigationBarTitleButton = UIButton(type: .System)
        navigationBarTitleButton.addTarget(self, action: #selector(userDidTapNavigationBarTitleButton), forControlEvents: .TouchUpInside)
        navigationItem.titleView = navigationBarTitleButton
    }

    func setNavigationBarTitleButtonTitle() {
        navigationBarTitleButton.setTitle("Chapter \(currentBookChapterIndex + 1) ▽", forState: .Normal)
        navigationBarTitleButton.sizeToFit()
    }

}

// MARK: Navigation bar button actions

private extension BookViewController {

    @objc func userDidTapNavigationBarTitleButton() {
        print("title tapped")
    }

    @IBAction func userDidTapLeftBarButtonItem() {
        loadPreviousChapter()
    }

    @IBAction func userDidTapRightBarButtonItem() {
        loadNextChapter()
    }

}

// MARK: Swipe gesture recognizer actions

private extension BookViewController {

    @IBAction func userDidSwipeLeft() {
        loadNextChapter()
    }

    @IBAction func userDidSwipeRight() {
        loadPreviousChapter()
    }

}
