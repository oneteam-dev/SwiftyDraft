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
    case InsertImage
    case AttachFile
    case Font
    case List
    case Emoji
    case Link

    static var all: [ButtonTag] {
        return [
            .Font,
            .List,
//            .Emoji,
            .InsertImage,
            .AttachFile,
            // .EmbedCode
        ]
    }
    
    static var fonts: [ButtonTag] {
        return [
            .Heading2,
            .Heading4,
            .Bold,
            .Italic,
            .Strikethrough
        ]
    }
    
    static var lists: [ButtonTag] {
        return [
            .CheckBox,
            .BulletedList,
            .NumberedList
        ]
    }
    

    var iconImage: UIImage {
        
        switch (self,NSLocale.preferredLanguages.first) {
        case (.Heading2, "ja-JP"?):
            return UIImage(named: "toolbar-icon-\(self.iconName)-jp", in: SwiftyDraft.resourceBundle, compatibleWith: nil)!
        case (.Heading4, "ja-JP"?):
            return UIImage(named: "toolbar-icon-\(self.iconName)-jp", in: SwiftyDraft.resourceBundle, compatibleWith: nil)!
        case (.Bold, "ja-JP"?):
            return UIImage(named: "toolbar-icon-\(self.iconName)-jp", in: SwiftyDraft.resourceBundle, compatibleWith: nil)!
        default:
            return UIImage(named: "toolbar-icon-\(self.iconName)", in: SwiftyDraft.resourceBundle, compatibleWith: nil)!
        }
    }

    var iconName: String {
        switch self {
        case .InsertLink: return "insert-link"
        case .RemoveLink: return "remove-link"
        case .Heading1: return "heading-1"
        case .Heading2: return "heading-2"
        case .Heading3: return "heading-3"
        case .Heading4: return "heading-4"
        case .Heading5: return "heading-5"
        case .Bold: return "bold"
        case .Italic: return "italic"
        case .Strikethrough: return "strikethrough"
        case .Blockquote: return "blockquote"
        case .CheckBox: return "check-box"
        case .BulletedList: return "bulleted-list"
        case .NumberedList: return "numbered-list"
        case .EmbedCode: return "embed"
        case .InsertImage: return "insert-picture"
        case .AttachFile: return "more"
        case .Font: return "text-heading"
        case .List: return "list-ul"
        case .Emoji: return "emoji"
        case .Link: return "bold"
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
