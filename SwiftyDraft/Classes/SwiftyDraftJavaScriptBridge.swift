//
//  SwiftyDraftJavaScriptBridge.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/9/16.
//
//

import WebKit
//import ISEmojiView



//extension SwiftyDraft: ISEmojiViewDelegate {
//    public func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
//        html += emoji
//        insertText(text: emoji)
//    }
//    public func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {
//        if html.characters.count > 0 {
//            var str = html
//            let range = str.index((str.endIndex), offsetBy: -1)..<(str.endIndex)
//            str.removeSubrange(range)
//            html = str
//            setDOMHTML(value: html)
//        }
//    }
//}


extension SwiftyDraft: WKScriptMessageHandler {
    
    func insertText(text:String) {
        runScript(script: "editor.editor.insertText(\"\(text)\")")
    }

    @objc func handleKeyboardChangeFrame(_ note: Notification) {
        //
        // FIXME! to much spaces in the bottom
        //
        // guard let h = self.runScript("window.innerHeight") else { return }
        // print("v", h)
        // runScript("document.getElementById('app-root').style.height = '\(h)px'")
        // runScript("document.getElementById('app-root').style.overflow = 'hidden'")
        // runScript("document.getElementById('app-root').style.backgroundColor = 'red'")
    }
    @objc func handleKeyboardWillShow(_ note: Notification) {
        emojiKeyboard?.removeFromSuperview()
        if let userInfo = note.userInfo{
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyBoardRect = keyboard.cgRectValue
                NSLog("\(keyBoardRect.size.height)")
                webView.frame = CGRect(x: webView.frame.origin.x,
                                    y: webView.frame.origin.y,
                                    width: webView.frame.size.width,
                                    height: self.frame.size.height-keyBoardRect.size.height)
                setEditorHeight(value: webView.frame.height-self.paddingTop)
                self.isAutoScrollDisable = true
            }
        }
    }
    
     @objc func handleKeyboardDidShow(_ note: Notification) {
        isAutoScrollDisable = false
    }
    
    @objc func handleKeyboardWillHide(_ note: Notification) {
        webView.frame = CGRect(x: webView.frame.origin.x,
                               y: webView.frame.origin.y,
                               width: webView.frame.size.width,
                               height: self.frame.size.height)
        setEditorHeight(value: webView.frame.height-self.paddingTop)
        self.isAutoScrollDisable = true
    }
    
    @objc func handleKeyboardDidHide(_ note: Notification) {
        isAutoScrollDisable = false
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
    
    func setEditorHeight(value: CGFloat) {
        let js = "document.getElementsByClassName('public-DraftEditor-content')[0].style.height = '100%';" +
            "document.getElementsByClassName('public-DraftEditor-content')[0].style.maxHeight = 'none';" +
            "document.getElementsByClassName('public-DraftEditor-content')[0].style.minHeight = '\(value)px';"
        self.webView.evaluateJavaScript(js, completionHandler: nil)
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
    func emojiPicker(buttonTag: ButtonTag, item: UIBarButtonItem) {
//        let baseView = UIView()
//        let emojiView = ISEmojiView()
//        emojiView.delegate = self
//        baseView.frame = CGRect(x: 0, y: 44,
//                                width: emojiView.frame.width, height: emojiView.frame.height)
//        baseView.addSubview(emojiView)
//        
//        emojiKeyboard = UIView()
//        let v = Toolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
//        v.editor = self
//        emojiKeyboard?.addSubview(v)
//        emojiKeyboard?.addSubview(baseView)
//
//        emojiKeyboard?.frame = CGRect(x: CGFloat(0), y: self.frame.height-(emojiView.frame.height + 44),
//                                     width: emojiView.frame.width, height: emojiView.frame.height)
//        self.endEditing(true)
//        self.addSubview(emojiKeyboard!)
    }
        
    public func subToolBarItems(tag: ButtonTag) -> [ButtonTag] {
        switch tag {
        case .Font:
            return ButtonTag.fonts
        case .List:
            return ButtonTag.lists
        default:
            return []
        }
    }
    
    func closePickerBar(item: UIBarButtonItem, completion: (() -> Void)? = nil) {
        var bar: UIToolbar?
        self.editorToolbar.subviews.forEach({ (b) in
            if let b = b as? UIToolbar {
                bar = b
            }
        })
        guard let removeBar = bar else {
            return
        }
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        removeBar.frame = CGRect(x: 0, y: 44,
                                                 width: self.editorToolbar.frame.width, height: 44)
        }, completion: { (_) in
            self.editorToolbar.frame = CGRect(x: 0, y: 0,
                                              width: self.frame.size.width,
                                              height: 44)
            let y = self.webView.scrollView.contentOffset.y - 44
            self.webView.scrollView.setContentOffset(CGPoint(x:0, y:y), animated: false)

            self.editorToolbar.toolbarItems.forEach({ (item) in
                item.tintColor = self.editorToolbar.unselectedTintColor
            })
            self.editorToolbar.showedToolbarItems = []
            removeBar.removeFromSuperview()
            completion?()
        })
    }
    
    @objc func toolbarButtonTapped(_ item: AnyObject?) {
        if let item = item as? UIBarButtonItem, let tag = ButtonTag(rawValue: item.tag) {
            itemOpen(tag, item)
        }
    }
    func itemOpen(_ buttonTag: ButtonTag, _ item: UIBarButtonItem) {
        if let js = buttonTag.javaScript {
            self.runScript(script: js)
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
//        let fn = {
//            self.webView.becomeFirstResponder()
//            self.runScript(script: "window.editor.focus()", completionHandler: nil)
//        }
//        if delayed {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: fn)
//        } else {
//            fn()
//        }
    }

    public func blur() {
        webView.becomeFirstResponder()
        self.runScript(script: "window.editor.blur()", completionHandler: nil)
    }

    func didChangeEditorState(html: String, inlineStyles: [InlineStyle], blockType: BlockType, isFocus:Bool) {
        self.editorToolbar.currentInlineStyles = inlineStyles
        self.editorToolbar.currentBlockType = blockType
        self.html = html
        if editing == false && isFocus == true {
            scrollY(offset: paddingTop - 10)
        }
        self.editing = isFocus
    }

    func didSetCallbackToken(token: String) {
        assert(token == callbackToken, "Callback token does not match with \(callbackToken) and \(token)")
        editorInitialized = true
        setDOMPaddingTop(value: paddingTop)
        setDOMPlaceholder(value: placeholder)
        setDOMHTML(value: defaultHTML)
    }
    
    open func runScript(script: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
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
                isFocused = (data["state"] as? NSNumber ?? 1).boolValue
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



