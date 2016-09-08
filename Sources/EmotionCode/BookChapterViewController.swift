import UIKit

// MARK: Main

final class BookChapterViewController: UIViewController {

    @IBOutlet private var bookChapterView: BookChapterView!
    var chapterIndex = 0
    var chapterURL: NSURL?
    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0

}

// MARK: Factory method

extension BookChapterViewController {

    static func instantiateFromStoryboard() -> BookChapterViewController {
        let storyboard = UIStoryboard(name: "Book", bundle: nil)
        let storyboardIdentifier = String(BookChapterViewController.self)
        guard let bookChapterViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardIdentifier) as? BookChapterViewController else {
            preconditionFailure("Unable to instantiate BookChapterViewController")
        }
        return bookChapterViewController
    }

}

// MARK: View lifecycle

extension BookChapterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChapter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookChapterView?.setPreferredLayoutGuidesForTop(preferredTopLayoutGuide, forBottom: preferredBottomLayoutGuide)
    }

}

// MARK: Load chapter HTML

private extension BookChapterViewController {

    func loadChapter() {
        guard let chapterURL = chapterURL else { return }
        do {
            let htmlString = try String(contentsOfURL: chapterURL)
            bookChapterView.webView.loadHTMLString(htmlString, baseURL: chapterURL)
        } catch {
            preconditionFailure("Unable to load chapter HTML file")
        }
    }

}
