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
    return SwiftyDraft.localizedStringForKey(key: key)
}

@IBDesignable open class SwiftyDraft: UIView, WKNavigationDelegate {

    public weak var imagePickerDelegate: SwiftyDraftImagePickerDelegate?
    public weak var filePickerDelegate: SwiftyDraftFilePickerDelegate?
    public var baseURL: URL?
    internal var emojiKeyboard:UIView?
    public var webViewContentHeight:CGFloat = 0.0
    internal var isAutoScrollDisable = false
    

    lazy var callbackToken: String = {
        var letters = Array("abcdefghijklmnopqrstuvwxyz".characters)
        let len = letters.count
        var randomString = ""

        while randomString.utf8.count < len {
            let idx = Int(arc4random_uniform(UInt32(letters.count)))
            randomString = "\(randomString)\(letters[idx])"
            letters.remove(at: idx)
        }

        return randomString
    }()

    public var editorInitialized: Bool = false
    public var editing:Bool = false

    public var defaultHTML: String = "" {
        didSet {
            if editorInitialized {
                setDOMHTML(value: html)
            }
        }
    }
    open var html: String = ""

    public var paddingTop: CGFloat = 0.0 {
        didSet(value) {
            if editorInitialized {
                setDOMPaddingTop(value: value)
            }
        }
    }

    public var placeholder: String = localizedStringForKey(key: "editor.placeholder") {
        didSet(value) {
            if editorInitialized {
                setDOMPlaceholder(value: value)
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

        let wv = WKWebView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), configuration: c)
        wv.navigationDelegate = self
        wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(wv)
        return wv
    }()

    public lazy var userContentController: WKUserContentController = {
        let uc = WKUserContentController()
        WebViewCallback.all.forEach {
            uc.add(self, name: $0.rawValue)
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

    public static var htmlURL: URL {
        return resourceBundle.url(forResource: "index", withExtension: "html")!
    }

    public static var javaScriptURL: URL {
        return resourceBundle.url(forResource: "bundle", withExtension: "js")!
    }

    public static var resourceBundle: Bundle {
        let bundleURL = Bundle(for: self).url(forResource: "SwiftyDraft", withExtension: "bundle")!
        return Bundle(url: bundleURL)!
    }

    static func localizedStringForKey(key: String) -> String {
        return NSLocalizedString(key, tableName: "SwiftyDraft",
                                 bundle: resourceBundle, value: "", comment: "")
    }

    public func setup() {
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.backgroundColor = UIColor.white
        self.webView.addRichEditorInputAccessoryView(toolbar: self.editorToolbar)
        let js = try! String(contentsOf: SwiftyDraft.javaScriptURL)
        let html = try! String(contentsOf: SwiftyDraft.htmlURL).replacingOccurrences(of: " src=\"./bundle.js\"><", with: "> window.onerror = function(e) { document.location.href = \"callback-\(callbackToken)://error.internal/\(WebViewCallback.DebugLog.rawValue)/\" + encodeURIComponent(JSON.stringify({ error: '' + e })); } </script><script>\(js)<")
        self.webView.loadHTMLString(html, baseURL: baseURL)

        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardChangeFrame(_:)),
                       name: .UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardWillShow(_:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardDidShow(_:)),
                                               name: .UIKeyboardDidShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardWillHide(_:)),
                                               name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardDidHide(_:)),
                                               name: .UIKeyboardDidHide, object: nil)

        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let editingView = webView.scrollView.subviews.filter{ $0.isFirstResponder }
        if keyPath != "contentSize" || editingView.count <= 0 {
            return
        }
        
        if isAutoScrollDisable {
            self.webViewContentHeight = self.webView.scrollView.contentSize.height
            return
        }
        if self.webViewContentHeight == 0 {
            self.webViewContentHeight = self.webView.scrollView.contentSize.height
            return
        }
        let scroll = self.webView.scrollView.contentSize.height - self.webViewContentHeight
        var scrollY:CGFloat = scroll + self.webView.scrollView.contentOffset.y
        if scrollY == webView.scrollView.contentOffset.y {
            return
        }
        self.scrollY(offset: scrollY)
        self.webViewContentHeight = self.webView.scrollView.contentSize.height
    }

    public func promptEmbedCode() {
        guard let vc = UIApplication.shared.keyWindow?.visibleViewController else {
            assertionFailure("View Controller does not exist")
            return
        }
        let ac = UIAlertController(
            title: localizedStringForKey(key: "embed_iframe.prompt.title"),
            message: localizedStringForKey(key: "embed_iframe.prompt.message"),
            preferredStyle: .alert)
        var textField: UITextField!
        ac.addTextField { tf in
            tf.placeholder = localizedStringForKey(key: "embed_iframe.placeholder")
            tf.keyboardType = .asciiCapable
            tf.autocorrectionType = .no
            textField = tf
        }
        ac.addAction(UIAlertAction(
            title: localizedStringForKey(key: "button.ok"),
            style: .default, handler: { _ in
                if let val = textField.text , val.hasPrefix("<iframe ") && val.hasSuffix("</iframe>") {
                    self.insertIFrame(src: val)
                }
                self.focus(delayed: true)
        }))
        ac.addAction(UIAlertAction(
            title: localizedStringForKey(key: "button.cancel"),
            style: .cancel, handler: { _ in
                self.focus(delayed: true)
        }))
        vc.present(ac, animated: true, completion: nil)
    }

    public func promptLinkURL() {
        guard let vc = UIApplication.shared.keyWindow?.visibleViewController else {
            assertionFailure("View Controller does not exist")
            return
        }
        let ac = UIAlertController(
            title: localizedStringForKey(key: "insert_link.prompt.title"),
            message: localizedStringForKey(key: "insert_link.prompt.message"),
            preferredStyle: .alert)
        var textField: UITextField!
        ac.addTextField { tf in
            tf.placeholder = "https://"
            tf.keyboardType = .URL
            textField = tf
        }
        ac.addAction(UIAlertAction(title: localizedStringForKey(key: "button.ok"), style: .default, handler: { _ in
            if let val = textField.text {
                self.insertLink(url: val)
            }
            self.focus(delayed: true)
        }))
        ac.addAction(UIAlertAction(title: localizedStringForKey(key: "button.cancel"), style: .cancel, handler: { _ in
            self.focus(delayed: true)
        }))
        vc.present(ac, animated: true, completion: nil)
    }

    public func openImagePicker() {
        self.imagePickerDelegate?.draftEditor(editor: self, requestImageAttachment: { result in
            self.insertImage(img: result)
            self.focus(delayed: true)
        })
    }

    public func openFilePicker() {
        self.filePickerDelegate?.draftEditor(editor: self, requestFileAttachment: { result in
            self.insertFileDownload(file: result)
            self.focus(delayed: true)
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}
