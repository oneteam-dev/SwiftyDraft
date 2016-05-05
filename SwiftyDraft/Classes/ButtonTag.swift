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
    case Heading
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
            .Heading,
            .Bold,
            .Italic,
            .Strikethrough,
            .Blockquote,
            .CheckBox,
            .BulletedList,
            .NumberedList
        ]
    }

    func iconImage(withHeadingLevel headingLevel: Int? = nil) -> UIImage {
        var iconName = "toolbar-icon-\(self.iconName)"
        if let headingLevel = headingLevel where self == .Heading {
            iconName = "\(iconName)-\(headingLevel)"
        }
        return UIImage(named: iconName, inBundle: SwiftyDraft.resourceBundle, compatibleWithTraitCollection: nil)!
    }

    var iconName: String {
        switch self {
        case InsertLink: return "insert-link"
        case RemoveLink: return "remove-link"
        case Heading: return "heading"
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
        case .Bold: return InlineStyle.Bold.javaScript
        case .Italic: return InlineStyle.Italic.javaScript
        case .Strikethrough: return InlineStyle.Strikethrough.javaScript
        case .Blockquote: return BlockType.Blockquote.javaScript
        case .CheckBox: return BlockType.CheckableListItem.javaScript
        case .BulletedList: return BlockType.OrderedListItem.javaScript
        case .NumberedList: return BlockType.UnorderedListItem.javaScript
        default: return nil
        }
    }
}