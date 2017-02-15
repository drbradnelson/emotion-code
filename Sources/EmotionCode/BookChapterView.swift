import UIKit
import WebKit

final class BookChapterView: UIView {

    let webView = WKWebView()

    var contentOffset: CGPoint = .zero

    // MARK: Configure web view

    func configureWebView() {
        webView.navigationDelegate = self
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

}

extension BookChapterView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if contentOffset != .zero {
            webView.scrollView.setContentOffset(contentOffset, animated: true)
            contentOffset = .zero
        }
    }

}
