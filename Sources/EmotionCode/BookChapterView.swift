import UIKit

final class BookChapterView: UIView {

    @IBOutlet private(set) var webView: UIWebView!

    // MARK: Layout

    func setPreferredLayoutGuidesForTop(_ top: CGFloat, forBottom bottom: CGFloat) {
        webView.scrollView.contentInset = UIEdgeInsets(top: top, left: webView.scrollView.contentInset.left, bottom: bottom, right: webView.scrollView.contentInset.right)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: top, left: webView.scrollView.scrollIndicatorInsets.left, bottom: bottom, right: webView.scrollView.scrollIndicatorInsets.right)
    }

}
