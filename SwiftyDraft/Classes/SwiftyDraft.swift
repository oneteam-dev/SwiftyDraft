//
//  SwiftyDraft.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit
import WebKit

func localizedStringForKey(key: String) -> String {
    return SwiftyDraft.localizedStringForKey(key)
}

@IBDesignable public class SwiftyDraft: UIView, WKNavigationDelegate {

    public weak var imagePickerDelegate: SwiftyDraftImagePickerDelegate?
    public weak var filePickerDelegate: SwiftyDraftFilePickerDelegate?
    public var baseURL:NSURL?

    lazy var callbackToken: String = {
        var letters = Array("abcdefghijklmnopqrstuvwxyz".characters)
        let len = letters.count
        var randomString = ""

        while randomString.utf8.count < len {
            let idx = Int(arc4random_uniform(UInt32(letters.count)))
            randomString = "\(randomString)\(letters[idx])"
            letters.removeAtIndex(idx)
        }

        return randomString
    }()

    public var editorInitialized: Bool = false

    public var defaultHTML: String = "" {
        didSet {
            if editorInitialized {
                setDOMHTML(html)
            }
        }
    }
    public var html: String = ""

    public var paddingTop: CGFloat = 0.0 {
        didSet(value) {
            if editorInitialized {
                setDOMPaddingTop(value)
            }
        }
    }

    public var placeholder: String = localizedStringForKey("editor.placeholder") {
        didSet(value) {
            if editorInitialized {
                setDOMPlaceholder(value)
            }
        }
    }

    public lazy var webView: WKWebView = {
        let c = WKWebViewConfiguration()
        if #available(iOS 9.0, *) {
            c.allowsAirPlayForMediaPlayback = true
            c.allowsPictureInPictureMediaPlayback = true
        }
        c.allowsInlineMediaPlayback = true
        c.userContentController = self.userContentController
        let wv = WKWebView(frame: self.frame, configuration: c)
        wv.navigationDelegate = self
        wv.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(wv)
        return wv
    }()

    public lazy var userContentController: WKUserContentController = {
        let uc = WKUserContentController()
        WebViewCallback.all.forEach {
            uc.addScriptMessageHandler(self, name: $0.rawValue)
        }
        return uc
    }()

    public lazy var editorToolbar: Toolbar = {
        let v = Toolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        v.editor = self
        return v
    }()

    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        get { return self.webView.scrollView.delegate }
        set(value) { self.webView.scrollView.delegate = value }
    }

    public static var htmlURL: NSURL {
        return resourceBundle.URLForResource("index", withExtension: "html")!
    }

    public static var javaScriptURL: NSURL {
        return resourceBundle.URLForResource("bundle", withExtension: "js")!
    }

    public static var resourceBundle: NSBundle {
        let b = NSBundle(forClass: self)
        let bundleURL = b.URLForResource("SwiftyDraft", withExtension: "bundle")!
        return NSBundle(URL: bundleURL)!
    }

    static func localizedStringForKey(key: String) -> String {
        return NSLocalizedString(key, tableName: "SwiftyDraft",
                                 bundle: resourceBundle, value: "", comment: "")
    }

    public func setup() {
        self.webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.webView.backgroundColor = UIColor.whiteColor()
        self.webView.addRichEditorInputAccessoryView(self.editorToolbar)
        let js = try! String(contentsOfURL: SwiftyDraft.javaScriptURL)
        let html = try! String(contentsOfURL: SwiftyDraft.htmlURL).stringByReplacingOccurrencesOfString(" src=\"./bundle.js\"><", withString: "> window.onerror = function(e) { document.location.href = \"callback-\(callbackToken)://error.internal/\(WebViewCallback.DebugLog.rawValue)/\" + encodeURIComponent(JSON.stringify({ error: '' + e })); } </script><script>\(js)<")
        self.webView.loadHTMLString(html, baseURL:baseURL)
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardChangeFrame(_:)),
                       name: UIKeyboardDidChangeFrameNotification, object: nil)
    }

    public func promptEmbedCode() {
        guard let vc = UIApplication.sharedApplication().keyWindow?.visibleViewController else {
            assertionFailure("View Controller does not exist")
            return
        }
        let ac = UIAlertController(
            title: localizedStringForKey("embed_iframe.prompt.title"),
            message: localizedStringForKey("embed_iframe.prompt.message"),
            preferredStyle: .Alert)
        var textField: UITextField!
        ac.addTextFieldWithConfigurationHandler { tf in
            tf.placeholder = localizedStringForKey("embed_iframe.placeholder")
            tf.keyboardType = .ASCIICapable
            tf.autocorrectionType = .No
            textField = tf
        }
        ac.addAction(UIAlertAction(
            title: localizedStringForKey("button.ok"),
            style: .Default, handler: { _ in
                if let val = textField.text where val.hasPrefix("<iframe ") && val.hasSuffix("</iframe>") {
                    self.insertIFrame(val)
                }
                self.focus(true)
        }))
        ac.addAction(UIAlertAction(
            title: localizedStringForKey("button.cancel"),
            style: .Cancel, handler: { _ in
                self.focus(true)
        }))
        vc.presentViewController(ac, animated: true, completion: nil)
    }

    public func promptLinkURL() {
        guard let vc = UIApplication.sharedApplication().keyWindow?.visibleViewController else {
            assertionFailure("View Controller does not exist")
            return
        }
        let ac = UIAlertController(
            title: localizedStringForKey("insert_link.prompt.title"),
            message: localizedStringForKey("insert_link.prompt.message"),
            preferredStyle: .Alert)
        var textField: UITextField!
        ac.addTextFieldWithConfigurationHandler { tf in
            tf.placeholder = "https://"
            tf.keyboardType = .URL
            textField = tf
        }
        ac.addAction(UIAlertAction(title: localizedStringForKey("button.ok"), style: .Default, handler: { _ in
            if let val = textField.text {
                self.insertLink(val)
            }
            self.focus(true)
        }))
        ac.addAction(UIAlertAction(title: localizedStringForKey("button.cancel"), style: .Cancel, handler: { _ in
            self.focus(true)
        }))
        vc.presentViewController(ac, animated: true, completion: nil)
    }

    public func openImagePicker() {
        self.imagePickerDelegate?.draftEditor(self, requestImageAttachment: { result in
            self.insertImage(result)
            self.focus(true)
        })
    }

    public func openFilePicker() {
        self.filePickerDelegate?.draftEditor(self, requestFileAttachment: { result in
            self.insertFileDownload(result)
            self.focus(true)
        })
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let b = self.bounds
        self.webView.frame = CGRect(origin: CGPointZero, size: b.size)
    }
}