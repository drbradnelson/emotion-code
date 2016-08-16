import UIKit

final class BookChapterViewController: UIViewController {

    @IBOutlet private(set) var webView: UIWebView!
    var chapterIndex = 0
    var chapterURL: NSURL?

}

// MARK: View lifecycle

extension BookChapterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChapter()
    }

}

// MARK: Load chapter html

private extension BookChapterViewController {

    func loadChapter() {
        guard let chapterURL = chapterURL else { return }
        do {
            let htmlString = try String(contentsOfURL: chapterURL)
            webView.loadHTMLString(htmlString, baseURL: chapterURL)
        } catch {
            print(error)
        }
    }

}
