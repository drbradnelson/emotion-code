import UIKit

// MARK: Main

final class BookChapterViewController: UIViewController {

    @IBOutlet private var webView: UIWebView!
    var chapterIndex = 0
    var chapterURL: NSURL?
    var preferredTopLayoutGuide: CGFloat = 0

}

// MARK: Factory method

extension BookChapterViewController {

    static func instantiateFromStoryboard() -> BookChapterViewController {
        let storyboard = UIStoryboard(name: "Book", bundle: nil)
        guard let bookChapterViewController = storyboard.instantiateViewControllerWithIdentifier(String(BookChapterViewController.self)) as? BookChapterViewController else {
            preconditionFailure("Couldn't instantiate BookChapterViewController")
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
        webView.scrollView.contentInset.top = preferredTopLayoutGuide
        webView.scrollView.scrollIndicatorInsets.top = preferredTopLayoutGuide
    }

}

// MARK: Load chapter HTML

private extension BookChapterViewController {

    func loadChapter() {
        guard let chapterURL = chapterURL else { return }
        do {
            let htmlString = try String(contentsOfURL: chapterURL)
            webView.loadHTMLString(htmlString, baseURL: chapterURL)
        } catch {
            preconditionFailure("Couldn't load chapter HTML file")
        }
    }

}
