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
    case EmbedCode

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
            // .EmbedCode
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
        case EmbedCode: return "embed"
        }
    }

    var blockType: BlockType? {
        switch self {
        case .Heading1: return .Heading1
        case .Heading2: return .Heading2
        case .Heading3: return .Heading3
        case .Heading4: return .Heading4
        case .Heading5: return .Heading5
        case .Blockquote: return .Blockquote
        case .CheckBox: return .CheckableListItem
        case .BulletedList: return .UnorderedListItem
        case .NumberedList: return .OrderedListItem
        default: return nil
        }
    }

    var inlineStyle: InlineStyle? {
        switch self {
        case .Bold: return .Bold
        case .Italic: return .Italic
        case .Strikethrough: return .Strikethrough
        default: return nil
        }
    }

    var javaScript: String? {
        if self == .RemoveLink {
            return "window.editor.toggleLink(null)"
        }
        return blockType?.javaScript ?? inlineStyle?.javaScript
    }
}