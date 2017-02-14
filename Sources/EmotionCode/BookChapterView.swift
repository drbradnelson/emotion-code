import UIKit
import WebKit

final class BookChapterView: UIView {

    let webView = WKWebView()

    // MARK: Configure web view

    func configureWebView() {
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
