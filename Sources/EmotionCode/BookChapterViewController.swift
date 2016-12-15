import UIKit
import Down

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
        loadChapter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookChapterView.insetContent(top: preferredTopLayoutGuide, bottom: preferredBottomLayoutGuide)
    }

    // MARK: Load chapter

    func loadChapter() {
        do {
            let htmlString = try loadMarkdownToHTMLString()
            bookChapterView.webView.loadHTMLString(htmlString, baseURL: nil)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
//        guard let chapterURL = chapterURL else { return }
//        do {
//            let htmlString = try String(contentsOf: chapterURL)
//            bookChapterView.webView.loadHTMLString(htmlString, baseURL: chapterURL)
//        } catch {
//            preconditionFailure()
//        }
    }

    private func loadMarkdownToHTMLString() throws ->  String {
        guard let markdownURL = Bundle.main.url(forResource: "Chapter 3", withExtension: "md") else {
            preconditionFailure("Unable to locate markdown file")
        }
        let markdownString = try String(contentsOf: markdownURL)
        let markdown = Down(markdownString: markdownString)
        let htmlString = try markdown.toHTML()
        return htmlString
    }

}
