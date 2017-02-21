//
//  SwiftyDraftImagePickerDelegate.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/10/16.
//
//

import Foundation

public struct SwiftyDraftImageResult {
    var name: String
    var originalURL: URL
    var previewURL: URL

    var json: String {
        let dict = [
            "alt": name,
            "url": originalURL.absoluteString,
            "title": name
        ]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                return json
            }
        } catch {}
        return "{}"
    }

    public init(name: String, originalURL: URL, previewURL: URL) {
        self.name = name
        self.originalURL = originalURL
        self.previewURL = previewURL
    }
}

public protocol SwiftyDraftImagePickerDelegate: class {
    func draftEditor(editor: SwiftyDraft,
               requestImageAttachment callback: @escaping (_ result: SwiftyDraftImageResult) -> Void)
}
