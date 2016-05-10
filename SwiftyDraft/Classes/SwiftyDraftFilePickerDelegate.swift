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
    var downloadURL: NSURL
    var dataSize: Int = -1

    var json: String {
        let dict = [
            "name": name,
            "download_url": downloadURL.absoluteString,
            "size": dataSize
        ]
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            if let json = String(data: data, encoding: NSUTF8StringEncoding) {
                return json
            }
        } catch {}
        return "{}"
    }

    public init(name: String, downloadURL: NSURL, dataSize: Int = -1) {
        self.name = name
        self.downloadURL = downloadURL
        self.dataSize = dataSize
    }
}

public protocol SwiftyDraftFilePickerDelegate: class {
    func draftEditor(editor: SwiftyDraft,
               requestFileAttachment callback: (result: SwiftyDraftFileResult) -> Void)
}