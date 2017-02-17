import UIKit
import WebKit

final class BookChapterView: UIView {

    let webView = WKWebView()

    fileprivate var restoredWebViewContentOffset: CGPoint?

    // MARK: Configure web view

    func configureWebView() {
        webView.navigationDelegate = self
        webView.restorationIdentifier = "BookChapterWebView"
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        let webViewConstraints = [webView.topAnchor.constraint(equalTo: topAnchor),
                                  webView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                  webView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                  webView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        NSLayoutConstraint.activate(webViewConstraints)
    }

    // MARK: Content inset

    func insetContent(top: CGFloat, bottom: CGFloat) {
        webView.scrollView.contentInset.top = top
        webView.scrollView.contentInset.bottom = bottom
        webView.scrollView.scrollIndicatorInsets.top = top
        webView.scrollView.scrollIndicatorInsets.bottom = bottom
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
        guard let restoredWebViewContentOffset = restoredWebViewContentOffset else { return }
        webView.scrollView.setContentOffset(restoredWebViewContentOffset, animated: true)
        self.restoredWebViewContentOffset = nil
    }

}
