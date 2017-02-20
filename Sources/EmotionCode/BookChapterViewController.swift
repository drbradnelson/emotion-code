import UIKit

final class BookChapterViewController: UIViewController {

    @IBOutlet private var bookChapterView: BookChapterView!

    var chapterIndex = 0
    var chapterURL: URL?
    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0

    // MARK: Instantiating from storyboard

    static func instantiateFromStoryboard() -> BookChapterViewController {
        guard let bookChapterViewController = BookChapterViewController.preferredStoryboard.instantiateViewController(withIdentifier: BookChapterViewController.preferredStoryboardIdentifier) as? BookChapterViewController else {
            preconditionFailure()
        }
        return bookChapterViewController
    }

    static let preferredStoryboard = UIStoryboard(name: "Book", bundle: nil)
    static let preferredStoryboardIdentifier = String(describing: BookChapterViewController.self)

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bookChapterView.configureWebView()
        loadChapter()
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontSizeDidChange(notification:)), name: .UIContentSizeCategoryDidChange, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bookChapterView.insetContent(top: preferredTopLayoutGuide, bottom: preferredBottomLayoutGuide)
    }

    // MARK: State preservation/restoration

    private let chapterIndexKey = "ChapterIndex"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(chapterIndex, forKey: chapterIndexKey)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        chapterIndex = coder.decodeInteger(forKey: chapterIndexKey)
        chapterURL = BookController().book.chapters[chapterIndex].fileURL
    }

    override func applicationFinishedRestoringState() {
        loadChapter()
    }

    // MARK: Preferred font size change

    func preferredFontSizeDidChange(notification: Notification) {
        loadChapter()
    }

    // MARK: Load chapter

    func loadChapter() {
        guard let chapterURL = chapterURL else { return }
        do {
            let htmlString = try String(contentsOf: chapterURL)
            bookChapterView.webView.loadHTMLString(htmlString, baseURL: chapterURL)
        } catch {
            preconditionFailure()
        }
    }

}
