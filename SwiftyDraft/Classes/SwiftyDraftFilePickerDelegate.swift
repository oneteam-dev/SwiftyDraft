//
//  SwiftyDraftFilePickerDelegate.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/10/16.
//
//

import Foundation

public struct SwiftyDraftFileResult {
    var name: String
    var downloadURL: URL
    var dataSize: Int = -1

    var json: String {
        let dict = [
            "name": name,
            "download_url": downloadURL.absoluteString,
            "size": "\(dataSize)"
        ]
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                return json
            }
        } catch {}
        return "{}"
    }

    public init(name: String, downloadURL: URL, dataSize: Int = -1) {
        self.name = name
        self.downloadURL = downloadURL
        self.dataSize = dataSize
    }
}

public protocol SwiftyDraftFilePickerDelegate: class {
    func draftEditor(editor: SwiftyDraft,
               requestFileAttachment callback: @escaping (_ result: SwiftyDraftFileResult) -> Void)
}
