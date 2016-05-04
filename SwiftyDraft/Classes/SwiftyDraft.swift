//
//  SwiftyDraft.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit
import WebKit


@IBDesignable public class SwiftyDraft: UIView, WKNavigationDelegate {

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

    public lazy var editorToolbar: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        v.backgroundColor = UIColor.redColor()
        return v
    }()

    public weak var scrollViewDelegate: UIScrollViewDelegate? {
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

    private func setup() {
        self.webView.loadFileURL(htmlURL, allowingReadAccessToURL: resourceBundle.bundleURL)
        self.webView.addRichEditorInputAccessoryView(self.editorToolbar)
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let b = self.bounds
        self.webView.frame = CGRect(origin: CGPointZero, size: b.size)
    }

    // MARK: - WKNavigationDelegate

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                        decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.Allow)
    }

    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.becomeFirstResponder()
        webView.evaluateJavaScript("window.editor.focus();", completionHandler: { (a, b) in

        })
    }

}