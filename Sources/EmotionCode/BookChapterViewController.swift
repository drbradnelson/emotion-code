import UIKit
import Down

final class BookChapterViewController: UIViewController {

    @IBOutlet private var bookChapterView: BookChapterView!

    var chapterIndex = 0
    var chapterURL: URL?
    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0
    private var templateURL: URL {
        guard let templateURL = Bundle.main.url(forResource: "main", withExtension: "html") else {
            preconditionFailure("Unable to locate markdown file")
        }
        return templateURL
    }
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookChapterView.insetContent(top: preferredTopLayoutGuide, bottom: preferredBottomLayoutGuide)
    }

    // MARK: Load chapter

    func loadChapter() {
        do {
            let htmlString = try loadMarkdownToHTMLString()
            let embeddedString = try embedHTMLStringIntoTemplate(htmlString)
            bookChapterView.webView.loadHTMLString(embeddedString, baseURL: templateURL)
        } catch {
            preconditionFailure(error.localizedDescription)
        }

    }

    private func embedHTMLStringIntoTemplate(_ htmlString: String) throws -> String {
        let templateHTML = try String(contentsOf: templateURL)
        guard let bodyTagRange = templateHTML.range(of: "<body>") else {
            preconditionFailure("Unable to locate body tag")
        }
        let bodyStart = templateHTML.substring(to: bodyTagRange.upperBound)
        let bodyEnd = templateHTML.substring(from: bodyTagRange.upperBound)
        let embeddedString = bodyStart + htmlString + bodyEnd
        return embeddedString
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
