//
//  SwiftyDraftUIWebViewDelegate.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/4/16.
//
//

import UIKit

extension SwiftyDraft: UIWebViewDelegate {

    public func webViewDidFinishLoad(webView: UIWebView) {
        webView.becomeFirstResponder()
        webView.stringByEvaluatingJavaScriptFromString("window.editor.focus()")
    }
    
}
