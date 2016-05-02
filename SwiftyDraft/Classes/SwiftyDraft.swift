//
//  SwiftyDraft.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit
import WebKit



@IBDesignable public class SwiftyDraft: UIView, WKNavigationDelegate, WKScriptMessageHandler {

    static let internalScheme = "swiftydraft-internal"

    enum EditorEvent: String {
        // window.webkit.messageHandlers.didChangeEditorState.postMessage(editorState);
        case ChangeState = "didChangeEditorState"
    }

    public lazy var webView: WKWebView = {
        let c = WKWebViewConfiguration()
        c.allowsAirPlayForMediaPlayback = true
        c.allowsInlineMediaPlayback = true
        c.allowsPictureInPictureMediaPlayback = true
        c.userContentController = self.userContentController
        let wv = WKWebView(frame: self.frame, configuration: c)
        wv.navigationDelegate = self
        wv.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(wv)
        return wv
    }()

    public lazy var userContentController: WKUserContentController = {
        let uc = WKUserContentController()
        uc.addScriptMessageHandler(self, name: EditorEvent.ChangeState.rawValue)
        return uc
    }()

    @IBOutlet public weak var scrollViewDelegate: UIScrollViewDelegate? {
        get { return self.webView.scrollView.delegate }
        set(value) { self.webView.scrollView.delegate = value }
    }

    public var htmlURL: NSURL {
        return resourceBundle.URLForResource("index", withExtension: "html")!
    }

    public var resourceBundle: NSBundle {
        let bundleURL = NSBundle(forClass: self.dynamicType).URLForResource("SwiftyDraft", withExtension: "bundle")!
        return NSBundle(URL: bundleURL)!
    }

    // MARK: - UIView

    public override func awakeFromNib() {
        super.awakeFromNib()
        let url = htmlURL
        self.webView.loadFileURL(url, allowingReadAccessToURL: resourceBundle.bundleURL)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let b = self.bounds
        self.webView.frame = CGRect(origin: CGPointZero, size: b.size)
    }

    // MARK: - WKNavigationDelegate

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                        decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let URL = navigationAction.request.URL
            , path = URL.path where URL.scheme == SwiftyDraft.internalScheme {
            self.handleInternalNavigation(path)
            decisionHandler(.Cancel)
            return
        }
        decisionHandler(.Allow)
    }

    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.becomeFirstResponder()
        webView.evaluateJavaScript("setTimeout(function(){ window.editor.focus() }, 1000)", completionHandler: nil)
    }

    // MARK: - WKScriptMessageHandler

    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        // TODO Handle mssages
    }

    // MARK: -

    private func handleInternalNavigation(path: String) {}

}