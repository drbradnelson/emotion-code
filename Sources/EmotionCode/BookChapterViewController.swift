import UIKit

// MARK: Main

final class BookChapterViewController: UIViewController {

    @IBOutlet private var bookChapterView: BookChapterView!

    var chapterIndex = 0
    var chapterURL: URL?
    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0

    // MARK: Instantiating from storyboard

    static func instantiateFromStoryboard() -> BookChapterViewController {
        guard let bookChapterViewController = BookChapterViewController.preferredStoryboard.instantiateViewController(withIdentifier: BookChapterViewController.preferredStoryboardIdentifier) as? BookChapterViewController else {
            preconditionFailure("Unable to instantiate BookChapterViewController")
        }
        return bookChapterViewController
    }

    static let preferredStoryboard = UIStoryboard(name: "Book", bundle: nil)
    static let preferredStoryboardIdentifier = String(describing: BookChapterViewController.self)

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChapter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookChapterView?.setPreferredLayoutGuidesForTop(preferredTopLayoutGuide, forBottom: preferredBottomLayoutGuide)
    }

    // MARK: Load chapter HTML

    func loadChapter() {
        guard let chapterURL = chapterURL else { return }
        do {
            let htmlString = try String(contentsOf: chapterURL)
            bookChapterView.webView.loadHTMLString(htmlString, baseURL: chapterURL)
        } catch {
            preconditionFailure("Unable to load chapter HTML file")
        }
    }

}
