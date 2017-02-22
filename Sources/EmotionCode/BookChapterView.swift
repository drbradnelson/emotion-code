import UIKit
import WebKit

final class BookChapterView: UIView {

    let webView = WKWebView()

    fileprivate var restoredWebViewContentOffset: CGPoint?

    private var webViewTopConstraint: NSLayoutConstraint?
    private var webViewBottomConstraint: NSLayoutConstraint?

    // MARK: Configure web view

    func configureWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        webViewTopConstraint = webView.topAnchor.constraint(equalTo: topAnchor)
        webViewBottomConstraint = webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        guard let webViewTopConstraint = webViewTopConstraint, let webViewBottomConstraint = webViewBottomConstraint else { return }
        let webViewConstraints = [webViewTopConstraint,
                                 webView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                  webViewBottomConstraint,
                                  webView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        NSLayoutConstraint.activate(webViewConstraints)
        webView.scrollView.layer.masksToBounds = false
    }

    // MARK: Content inset

    func insetContent(top: CGFloat, bottom: CGFloat) {
        // NOTE: Workaround for WKWebView content insets http://stackoverflow.com/questions/33922076/wkwebviewcontentinset-makes-content-size-wrong
        webViewTopConstraint?.constant = top
        webViewBottomConstraint?.constant = -bottom
    }

    // MARK: State preservation/restoration

    private let webViewContentOffsetKey = "WebViewContentOffsetKey"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(webView.scrollView.contentOffset, forKey: webViewContentOffsetKey)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        restoredWebViewContentOffset = coder.decodeCGPoint(forKey: webViewContentOffsetKey)
    }

}

extension BookChapterView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let contentOffset = restoredWebViewContentOffset else { return }
        webView.scrollView.setContentOffset(contentOffset, animated: true)
        restoredWebViewContentOffset = nil
    }

}
