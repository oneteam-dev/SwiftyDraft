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
    var originalURL: NSURL
    var previewURL: NSURL

    var json: String {
        let dict = [
            "name": name,
            "original_url": originalURL.absoluteString,
            "preview_url": previewURL.absoluteString
        ]
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            if let json = String(data: data, encoding: NSUTF8StringEncoding) {
                return json
            }
        } catch {}
        return "{}"
    }

    public init(name: String, originalURL: NSURL, previewURL: NSURL) {
        self.name = name
        self.originalURL = originalURL
        self.previewURL = previewURL
    }
}

public protocol SwiftyDraftImagePickerDelegate: class {
    func draftEditor(editor: SwiftyDraft,
               requestImageAttachment callback: (result: SwiftyDraftImageResult) -> Void)
}