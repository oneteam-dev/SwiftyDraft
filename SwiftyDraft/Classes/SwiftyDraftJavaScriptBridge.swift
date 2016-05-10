//
//  SwiftyDraftJavaScriptBridge.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/9/16.
//
//

import UIKit

extension SwiftyDraft: UIWebViewDelegate {

    func handleKeyboardChangeFrame(note: NSNotification) {
        // FIXME!
        //guard let h = self.runScript("window.innerHeight") else { return }
        //print("v", h)
        //runScript("document.getElementById('app-root').style.height = '\(h)px'")
        //runScript("document.getElementById('app-root').style.overflow = 'hidden'")
        //runScript("document.getElementById('app-root').style.backgroundColor = 'red'")
    }

    public var editorInitialized: Bool {
        return runScript("!!window.editor") == "true"
    }

    func toolbarButtonTapped(buttonTag: ButtonTag, _ item: UIBarButtonItem) {
        if let js = buttonTag.javaScript {
            runScript(js)
        } else if buttonTag == .InsertLink {
            promptLinkURL()
        }
    }

    var html: String {
        return runScript("window.editor.getHTML()") ?? ""
    }

    func setCallbackToken() {
        runScript("window.editor.setCallbackToken(\"\(callbackToken)\")")
    }

    func insertLink(url: String) {
        runScript("window.editor.toggleLink(\"\(url)\")")
    }

    func focus() {
        webView.becomeFirstResponder()
        runScript("window.editor.focus()")
    }

    func blur() {
        webView.becomeFirstResponder()
        runScript("window.editor.blur()")
    }

    func didChangeEditorState(withInlineStyles inlineStyles: [InlineStyle], blockType: BlockType) {
        self.editorToolbar.currentInlineStyles = inlineStyles
        self.editorToolbar.currentBlockType = blockType
    }

    func didSetCallbackToken(token: String) {
        assert(token == callbackToken, "Callback token does not match with \(callbackToken) and \(token)")
    }

    private func runScript(script: String) -> String? {
        let js = "(function(){ try { return \(script); } catch(e) { return e + '' } }).call()"
        let res = self.webView.stringByEvaluatingJavaScriptFromString(js)
        if let res = res where res.hasPrefix("TypeError:") {
            print(res)
        }
        return res
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

    public func webViewDidFinishLoad(webView: UIWebView) {
        focus()
        setCallbackToken()
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
