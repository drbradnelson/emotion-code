import UIKit

// MARK: Main

final class BookViewController: UIViewController {

    @IBOutlet private var webView: UIWebView!
    private var navigationBarTitleButton: UIButton!
    private let bookController = BookController()
    private var currentBookChapter: BookChapter?
    private var currentBookChapterIndex = 0

}

// MARK: View lifecycle

extension BookViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonForNavigationBarTitle()
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
