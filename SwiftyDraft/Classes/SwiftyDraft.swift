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

open class SwiftyDraft: UIView, WKNavigationDelegate {

    public weak var imagePickerDelegate: SwiftyDraftImagePickerDelegate?
    public weak var filePickerDelegate: SwiftyDraftFilePickerDelegate?
    public var baseURL: URL?
    internal var emojiKeyboard:UIView?
    public var webViewContentHeight:CGFloat = 0.0
    internal var isAutoScrollDisable = false
    public var mentions = Array<SwiftyDraftMentionable>()

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
        WebViewCallback.allCases.forEach {
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
                                               name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardDidShow(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SwiftyDraft.handleKeyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
        
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
        let ac = UIAlertController(
            title: SwiftyDraft.localizedStringForKey(key: "embed_iframe.prompt.title"),
            message: SwiftyDraft.localizedStringForKey(key: "embed_iframe.prompt.message"),
            preferredStyle: .alert)
        var textField: UITextField!
        ac.addTextField { tf in
            tf.placeholder = SwiftyDraft.localizedStringForKey(key: "embed_iframe.placeholder")
            tf.keyboardType = .asciiCapable
            tf.autocorrectionType = .no
            textField = tf
        }
        ac.addAction(UIAlertAction(
            title: SwiftyDraft.localizedStringForKey(key: "button.ok"),
            style: .default, handler: { _ in
                if let val = textField.text , val.hasPrefix("<iframe ") && val.hasSuffix("</iframe>") {
                    self.insertIFrame(src: val)
                }
                self.focus(delayed: true)
        }))
        ac.addAction(UIAlertAction(
            title: SwiftyDraft.localizedStringForKey(key: "button.cancel"),
            style: .cancel, handler: { _ in
                self.focus(delayed: true)
        }))
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(ac, animated: true, completion: nil)
    }

    public func promptLinkURL() {
        let ac = UIAlertController(
            title: SwiftyDraft.localizedStringForKey(key: "insert_link.prompt.title"),
            message: SwiftyDraft.localizedStringForKey(key: "insert_link.prompt.message"),
            preferredStyle: .alert)
        var textField: UITextField!
        ac.addTextField { tf in
            tf.placeholder = "https://"
            tf.keyboardType = .URL
            textField = tf
        }
        ac.addAction(UIAlertAction(title: SwiftyDraft.localizedStringForKey(key: "button.ok"), style: .default, handler: { _ in
            if let val = textField.text {
                self.insertLink(url: val)
            }
            self.focus(delayed: true)
        }))
        ac.addAction(UIAlertAction(title: SwiftyDraft.localizedStringForKey(key: "button.cancel"), style: .cancel, handler: { _ in
            self.focus(delayed: true)
        }))
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(ac, animated: true, completion: nil)
    }

    public func openImagePicker() {
        self.imagePickerDelegate?.draftEditor(editor: self, requestImageAttachment: { result in
            self.insertImage(img: result)
            self.focus(delayed: true)
        })
    }
    
    public func openCamera() {
        self.imagePickerDelegate?.draftEditor(editor: self, requestCameraAttachment: { (result) in
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
    
    open func toolbarButtonTapped(_ buttonTag: ButtonTag, _ item: UIBarButtonItem, toolBar: Toolbar) {
        
        if toolBar == editorToolbar {
            switch buttonTag {
            case .InsertLink:
                promptLinkURL()
            case .EmbedCode:
                promptEmbedCode()
            case .AttachFile:
                openFilePicker()
            case .InsertImage:
                openImagePicker()
            case .Camera:
                openCamera()
            case .Emoji:
                emojiPicker(buttonTag: buttonTag, item: item)
            case .Font, .List:
                openHeaderPicker(buttonTag: buttonTag, item: item)
            default:
                if let js = buttonTag.javaScript {
                    self.runScript(script: js)
                }
            }
        } else {
            emojiKeyboard?.removeFromSuperview()
            focus(delayed: false)
            toolbarButtonTapped(buttonTag, item, toolBar: self.editorToolbar)
        }
    }
    
    open func openHeaderPicker(buttonTag: ButtonTag, item: UIBarButtonItem) {
        
        if self.editorToolbar.showedToolbarItems.count == 0 {
            
            let bar = UIToolbar(frame: CGRect(x: 0, y: 44,
                                              width: self.editorToolbar.frame.width, height: 44)
            )
            let f = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            var items: [UIBarButtonItem] = [f]
            bar.barTintColor = UIColor.white
            bar.backgroundColor = UIColor.clear
            
            for t in subToolBarItems(tag: buttonTag) {
                switch t {
                case .Space:
                    let  flexibleItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                    flexibleItem.width = 63.0
                    let f = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                    items.append(flexibleItem)
                    items.append(f)
                default:
                    let item = UIBarButtonItem(
                        image: t.iconImage, style: .plain,
                        target: self, action:  #selector(toolbarButtonTapped(_:)))
                    item.tag = t.rawValue
                    item.tintColor = self.editorToolbar.unselectedTintColor
                    items.append(item)
                    items.append(f)
                }
            }
            
            bar.items = items
            self.editorToolbar.showedToolbarItems = items
            item.tintColor = self.editorToolbar.selectedTintColor
            self.editorToolbar.insertSubview(bar, at: 0)
            bar.layer.borderWidth = 0.0
            self.editorToolbar.translatesAutoresizingMaskIntoConstraints = true
            UIView.animate(withDuration: 0.2, animations: {
                self.editorToolbar.frame = CGRect(x: 0, y: 0,
                                                  width: self.frame.size.width,
                                                  height: 88)
                bar.frame = CGRect(x: 0, y: 0, width: self.editorToolbar.frame.width, height: 44)
                let y = self.webView.scrollView.contentOffset.y + 44
                self.webView.scrollView.setContentOffset(CGPoint(x:0, y:y), animated: false)
            })
        } else {
            let flag = item.tintColor != self.editorToolbar.selectedTintColor
            closePickerBar(item: item, completion: {[weak self] in
                if flag {
                    self?.openHeaderPicker(buttonTag: buttonTag, item: item)
                }
            })
        }
    }

}
