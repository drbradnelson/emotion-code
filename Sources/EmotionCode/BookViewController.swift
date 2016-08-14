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
    }

}

// MARK: Navigation bar button actions

private extension BookViewController {

    @objc func userDidTapNavigationBarTitleButton() {
        print("title tapped")
    }

}
