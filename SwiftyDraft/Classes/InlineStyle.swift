//
//  InlineStyle.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

public enum InlineStyle: String {
    case Bold = "BOLD"
    case Italic = "ITALIC"
    case Strikethrough = "STRIKETHROUGH"

    var javaScript: String {
        return "window.editor.toggleInlineStyle(\"\(self.rawValue)\")"
    }
}
