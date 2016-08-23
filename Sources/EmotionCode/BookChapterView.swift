import UIKit

// MARK: Main

final class BookChapterView: UIView {

    @IBOutlet var webView: UIWebView!

}

// MARK: Layout

extension BookChapterView {

    func setPreferredLayoutGuidesForTop(top: CGFloat, forBottom bottom: CGFloat) {
        webView.scrollView.contentInset = UIEdgeInsets(top: top, left: webView.scrollView.contentInset.left, bottom: bottom, right: webView.scrollView.contentInset.right)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: top, left: webView.scrollView.scrollIndicatorInsets.left, bottom: bottom, right: webView.scrollView.scrollIndicatorInsets.right)
    }

}
