//
//  SwiftyDraftMessageHandler.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit
import WebKit

extension SwiftyDraft: WKScriptMessageHandler {

    enum EditorEvent: String {
        // window.webkit.messageHandlers.didChangeEditorState.postMessage(editorState);
        case ChangeState = "didChangeEditorState"
    }

    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        // TODO Handle mssages
    }

}