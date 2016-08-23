import UIKit

// MARK: Main

final class BookChapterView: UIView {

    @IBOutlet var webView: UIWebView!

    var preferredTopLayoutGuide: CGFloat = 0
    var preferredBottomLayoutGuide: CGFloat = 0

}

// MARK: Layout

extension BookChapterView {

    override func layoutSubviews() {
        super.layoutSubviews()
        webView.scrollView.contentInset = UIEdgeInsets(top: preferredTopLayoutGuide, left: webView.scrollView.contentInset.left, bottom: preferredBottomLayoutGuide, right: webView.scrollView.contentInset.right)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: preferredTopLayoutGuide, left: webView.scrollView.scrollIndicatorInsets.left, bottom: preferredBottomLayoutGuide, right: webView.scrollView.scrollIndicatorInsets.right)
    }

}
