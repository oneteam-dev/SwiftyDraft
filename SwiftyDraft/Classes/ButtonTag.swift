//
//  ButtonTag.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/6/16.
//
//

import Foundation

enum ButtonTag: Int {
    case InsertLink = 1000
    case RemoveLink
    case Heading1
    case Heading2
    case Heading3
    case Heading4
    case Heading5
    case Bold
    case Italic
    case Strikethrough
    case Blockquote
    case CheckBox
    case BulletedList
    case NumberedList

    static var all: [ButtonTag] {
        return [
            .InsertLink,
            .RemoveLink,
            .Bold,
            .Italic,
            .Strikethrough,
            .Blockquote,
            .CheckBox,
            .BulletedList,
            .NumberedList,
            .Heading1,
            .Heading2,
            .Heading3,
            .Heading4,
            .Heading5
        ]
    }

    var iconImage: UIImage {
        return UIImage(named: "toolbar-icon-\(self.iconName)",
                       inBundle: SwiftyDraft.resourceBundle,
                       compatibleWithTraitCollection: nil)!
    }

    var iconName: String {
        switch self {
        case InsertLink: return "insert-link"
        case RemoveLink: return "remove-link"
        case Heading1: return "heading-1"
        case Heading2: return "heading-2"
        case Heading3: return "heading-3"
        case Heading4: return "heading-4"
        case Heading5: return "heading-5"
        case Bold: return "bold"
        case Italic: return "italic"
        case Strikethrough: return "strikethrough"
        case Blockquote: return "blockquote"
        case CheckBox: return "check-box"
        case BulletedList: return "bulleted-list"
        case NumberedList: return "numbered-list"
        }
    }

    var javaScript: String? {
        switch self {
        case .Heading1: return BlockType.Heading1.javaScript
        case .Heading2: return BlockType.Heading2.javaScript
        case .Heading3: return BlockType.Heading3.javaScript
        case .Heading4: return BlockType.Heading4.javaScript
        case .Heading5: return BlockType.Heading5.javaScript
        case .Bold: return InlineStyle.Bold.javaScript
        case .Italic: return InlineStyle.Italic.javaScript
        case .Strikethrough: return InlineStyle.Strikethrough.javaScript
        case .Blockquote: return BlockType.Blockquote.javaScript
        case .CheckBox: return BlockType.CheckableListItem.javaScript
        case .BulletedList: return BlockType.UnorderedListItem.javaScript
        case .NumberedList: return BlockType.OrderedListItem.javaScript
        default: return nil
        }
    }
}