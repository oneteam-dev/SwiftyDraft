//
//  SwiftyDraftJavaScriptBridge.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/9/16.
//
//

import WebKit

extension SwiftyDraft: WKScriptMessageHandler {

    func handleKeyboardChangeFrame(_ note: Notification) {
        //
        // FIXME! to much spaces in the bottom
        //
        // guard let h = self.runScript("window.innerHeight") else { return }
        // print("v", h)
        // runScript("document.getElementById('app-root').style.height = '\(h)px'")
        // runScript("document.getElementById('app-root').style.overflow = 'hidden'")
        // runScript("document.getElementById('app-root').style.backgroundColor = 'red'")
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let c = WebViewCallback(rawValue: message.name) {
            self.handleWebViewCallback(callback: c, data: message.body as AnyObject?)
        } else {
            fatalError("Unknown callback \(message.body)")
        }
    }

    func setDOMPaddingTop(value: CGFloat) {
        runScript(script: "window.editor.paddingTop = \(value)", completionHandler: nil)
    }
    
    func setEditorHeight() {
        runScript(script: "document.getElementsByClassName('public-DraftEditor-content')[0].style.height = '100%'")
        runScript(script: "document.getElementsByClassName('public-DraftEditor-content')[0].style.maxHeight = 'none'")
        runScript(script: "document.getElementsByClassName('public-DraftEditor-content')[0].style.minHeight = '100vh'")
    }
    
    func scrollY(offset: CGFloat) {
        runScript(script: "window.scrollTo(0, \(offset))")
    }

    func setDOMPlaceholder(value: String) {
        runScript(script: "window.editor.placeholder = \"\(value)\"")
    }

    func setDOMHTML(value: String) {
        if editorInitialized {
            runScript(script: "window.editor.setHTML(\(value.javaScriptEscapedString()))")
        }
    }

    func toolbarButtonTapped(_ buttonTag: ButtonTag, _ item: UIBarButtonItem) {
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
                self.runScript(script: js)
            }
        }
    }

    func setCallbackToken() {
        self.runScript(script: "window.editor.setCallbackToken(\"\(callbackToken)\")")
        
    }

    public func insertLink(url: String) {
        self.runScript(script: "window.editor.toggleLink(\"\(url)\")")
    }

    public func insertIFrame(src: String) {
        self.runScript(script: "window.editor.insertIFrame(\"\(src)\")")
    }

    public func insertImage(img: SwiftyDraftImageResult) {
        self.runScript(script: "window.editor.insertImage(\(img.json))")
    }

    public func insertFileDownload(file: SwiftyDraftFileResult) {
        self.runScript(script: "window.editor.insertDownloadLink(\(file.json))")
    }

    public func focus(delayed: Bool = false) {
        let fn = {
            self.webView.becomeFirstResponder()
            self.runScript(script: "window.editor.focus()", completionHandler: nil)
        }
        if delayed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: fn)
        } else {
            fn()
        }
    }

    public func blur() {
        webView.becomeFirstResponder()
        self.runScript(script: "window.editor.blur()", completionHandler: nil)
    }

    func didChangeEditorState(html: String, inlineStyles: [InlineStyle], blockType: BlockType, isFocus:Bool) {
        self.editorToolbar.currentInlineStyles = inlineStyles
        self.editorToolbar.currentBlockType = blockType
        self.html = html
        if isFocus == true && self.editing == false {
            scrollY(offset: self.paddingTop - 10)
        }
        setEditorHeight()
        self.editing = isFocus
    }

    func didSetCallbackToken(token: String) {
        assert(token == callbackToken, "Callback token does not match with \(callbackToken) and \(token)")
        editorInitialized = true
        setDOMPaddingTop(value: paddingTop)
        setDOMPlaceholder(value: placeholder)
        setDOMHTML(value: defaultHTML)
        setEditorHeight()
    }
    
    private func runScript(script: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        let js = "(function(){ try { return \(script); } catch(e) { window.webkit.messageHandlers.debugLog.postMessage(e + '') } }).call()"
        self.webView.evaluateJavaScript(js, completionHandler: completionHandler)
    }

    private func handleWebViewCallback(callback: WebViewCallback, data: AnyObject?) {
        switch callback {
        case .DidSetCallbackToken:
            didSetCallbackToken(token: data as! String)
        case .DidChangeEditorState:
            let inlineStyles = ((data?["inlineStyles"] as? [String]) ?? [String]()).map({ InlineStyle(rawValue: $0)! })
            let blockType = BlockType(rawValue: (data?["blockType"] as? String) ?? "") ?? .Unstyled
            let html = data?["html"] as? String ?? ""
            var isFocused = false
            if let data = data as? NSDictionary {
                isFocused = (data["state"] as! NSNumber ?? 1).boolValue
            }
            didChangeEditorState(html: html, inlineStyles: inlineStyles, blockType: blockType, isFocus: isFocused)

        case .DebugLog:
            print("[DEBUG] \(data)")
        }
    }

    // MARK: - WKNavigationDelegate
    
    @objc(webView:didFinishNavigation:) public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !editorInitialized {
            if isFirstResponder {
                focus()
            }
            setCallbackToken()
        }
    }
}
