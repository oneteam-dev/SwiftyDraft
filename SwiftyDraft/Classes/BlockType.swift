//
//  BlockType.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

public enum BlockType: String {
    case Unstyled = "unstyled"
    case Heading1 = "header-one"
    case Heading2 = "header-two"
    case Heading3 = "header-three"
    case Heading4 = "header-four"
    case Heading5 = "header-five"
    case Blockquote = "blockquote"
    case OrderedListItem = "ordered-list-item"
    case UnorderedListItem = "unordered-list-item"
    case CheckableListItem = "checkable-list-item"
    case Atomic = "atomic"

    var javaScript: String {
        return "window.editor.toggleBlockType(\"\(self.rawValue)\")"
    }
}
