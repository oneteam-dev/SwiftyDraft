//
//  SwiftyDraftJavaScriptBridge.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/9/16.
//
//

import WebKit

extension SwiftyDraft: WKScriptMessageHandler {

    func handleKeyboardChangeFrame(note: NSNotification) {
        //
        // FIXME! to much spaces in the bottom
        //
        // guard let h = self.runScript("window.innerHeight") else { return }
        // print("v", h)
        // runScript("document.getElementById('app-root').style.height = '\(h)px'")
        // runScript("document.getElementById('app-root').style.overflow = 'hidden'")
        // runScript("document.getElementById('app-root').style.backgroundColor = 'red'")
    }


    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let c = WebViewCallback(rawValue: message.name) {
            self.handleWebViewCallback(c, data: message.body)
        } else {
            fatalError("Unknown callback \(message.body)")
        }
    }

    func setDOMPaddingTop(value: CGFloat) {
        runScript("window.editor.paddingTop = \(value)", completionHandler: nil)
    }

    func setDOMPlaceholder(value: String) {
        runScript("window.editor.placeholder = \"\(value)\"")
    }

    func toolbarButtonTapped(buttonTag: ButtonTag, _ item: UIBarButtonItem) {
        switch buttonTag {
        case .InsertLink:
            promptLinkURL()
        case .EmbedCode:
            promptEmbedCode()
        case .AttachFile:
            openFilePicker()
        case .InsertImage:
            openImagePicker()
        default:
            if let js = buttonTag.javaScript {
                self.runScript(js)
            }
        }
    }

    var domHTML: String {
        get {
            // return runScript("window.editor.getHTML()") ?? ""
            return ""
        }
        set(value) {
            if editorInitialized {
                runScript("window.editor.setHTML(\(value.javaScriptEscapedString()))")
            }
        }
    }

    func setCallbackToken() {
        self.runScript("window.editor.setCallbackToken(\"\(callbackToken)\")")
        
    }

    public func insertLink(url: String) {
        self.runScript("window.editor.toggleLink(\"\(url)\")")
    }

    public func insertIFrame(src: String) {
        self.runScript("window.editor.insertIFrame(\"\(src)\")")
    }

    public func insertImage(img: SwiftyDraftImageResult) {
        self.runScript("window.editor.insertImage(\(img.json))")
    }

    public func insertFileDownload(file: SwiftyDraftFileResult) {
        self.runScript("window.editor.insertDownloadLink(\(file.json))")
    }

    public func focus(delayed: Bool = false) {
        let fn = {
            self.webView.becomeFirstResponder()
            self.runScript("window.editor.focus()", completionHandler: nil)
        }
        if delayed {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), fn)
        } else {
            fn()
        }
    }

    public func blur() {
        webView.becomeFirstResponder()
        self.runScript("window.editor.blur()", completionHandler: nil)
    }

    func didChangeEditorState(withInlineStyles inlineStyles: [InlineStyle], blockType: BlockType) {
        self.editorToolbar.currentInlineStyles = inlineStyles
        self.editorToolbar.currentBlockType = blockType
    }

    func didSetCallbackToken(token: String) {
        assert(token == callbackToken, "Callback token does not match with \(callbackToken) and \(token)")
        editorInitialized = true
        setDOMPaddingTop(paddingTop)
        setDOMPlaceholder(placeholder)
        domHTML = html
    }

    private func runScript(script: String, completionHandler: ((AnyObject?, NSError?) -> Void)? = nil) {
        let js = "(function(){ try { return \(script); } catch(e) { window.webkit.messageHandlers.debugLog.postMessage(e + '') } }).call()"
        self.webView.evaluateJavaScript(js, completionHandler: completionHandler)
    }

    private func handleWebViewCallback(callback: WebViewCallback, data: AnyObject?) {
        switch callback {
        case .DidSetCallbackToken:
            didSetCallbackToken(data as! String)
        case .DidChangeEditorState:
            let inlineStyles = ((data?["inlineStyles"] as? [String]) ?? [String]()).map({ InlineStyle(rawValue: $0)! })
            let blockType = BlockType(rawValue: (data?["blockType"] as? String) ?? "") ?? .Unstyled
            didChangeEditorState(withInlineStyles: inlineStyles, blockType: blockType)
        case .DebugLog:
            print("[DEBUG] \(data)")
        }
    }

    // MARK: - UIWebViewDelegate

    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if self.isFirstResponder() {
            focus()
        }
        setCallbackToken()
    }

    public func webViewDidFinishLoad(webView: UIWebView) {
    }

    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
                        navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL
            , pathComponents = url.pathComponents
            , callback = WebViewCallback(rawValue: pathComponents[1])
            where url.scheme == "callback-\(callbackToken)" {
            do {
                let data = try NSJSONSerialization.JSONObjectWithData(
                    pathComponents[2].dataUsingEncoding(NSUTF8StringEncoding)!,
                    options: .AllowFragments)
                self.handleWebViewCallback(callback, data: data)
            } catch {
                self.handleWebViewCallback(callback, data: nil)
            }
            return false
        }
        return true
    }
}
