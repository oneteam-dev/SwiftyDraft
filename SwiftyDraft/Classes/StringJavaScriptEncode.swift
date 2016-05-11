//
//  StringJavaScriptEncode.swift
//  https://gist.github.com/pwightman/64c57076b89c5d7f8e8c
//
//  Created by Atsushi Nagase on 5/11/16.
//
//

import Foundation

extension String {
    func javaScriptEscapedString() -> String {
        // Because JSON is not a subset of JavaScript, the LINE_SEPARATOR and PARAGRAPH_SEPARATOR unicode
        // characters embedded in (valid) JSON will cause the webview's JavaScript parser to error. So we
        // must encode them first. See here: http://timelessrepo.com/json-isnt-a-javascript-subset
        // Also here: http://media.giphy.com/media/wloGlwOXKijy8/giphy.gif
        let str = self
            .stringByReplacingOccurrencesOfString("\u{2028}", withString: "\\u2028")
            .stringByReplacingOccurrencesOfString("\u{2029}", withString: "\\u2029")
        // Because escaping JavaScript is a non-trivial task (https://github.com/johnezang/JSONKit/blob/master/JSONKit.m#L1423)
        // we proceed to hax instead:
        let data = try! NSJSONSerialization.dataWithJSONObject([str], options: [])
        let encodedString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        return encodedString.substringWithRange(NSMakeRange(1, encodedString.length - 2))
    }
}