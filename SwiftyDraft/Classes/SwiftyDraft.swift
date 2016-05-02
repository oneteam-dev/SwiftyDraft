//
//  SwiftyDraft.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit
import WebKit



public class SwiftyDraft: UIView, WKNavigationDelegate {

    static let internalScheme = "swiftydraft-internal"

    public lazy var webView: WKWebView = {
        let c = WKWebViewConfiguration()
        c.allowsAirPlayForMediaPlayback = true
        c.allowsInlineMediaPlayback = true
        c.allowsPictureInPictureMediaPlayback = true
        let wv = WKWebView(frame: CGRectZero, configuration: c)
        wv.navigationDelegate = self
        self.addSubview(wv)
        return wv
    }()

    // MARK: - WKNavigationDelegate

    public func webView(webView: WKWebView,
                        decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                                                        decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let URL = navigationAction.request.URL
            , path = URL.path where URL.scheme == SwiftyDraft.internalScheme {
            self.handleInternalNavigation(path)
        }
        decisionHandler(.Cancel)
    }

    // MARK: -

    private func handleInternalNavigation(path: String) {}
    
}