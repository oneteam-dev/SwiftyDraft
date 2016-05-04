//
//  Toolbar.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/4/16.
//
//

import UIKit

public class Toolbar: UIView {

    enum ButtonTag: Int {
        case InsertLink
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

        var iconImage: UIImage {
            return UIImage(named: "toolbar-icon-\(iconName)", inBundle: SwiftyDraft.resourceBundle, compatibleWithTraitCollection: nil)!
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

    public let scrollView = UIScrollView()
    private let toolbar = UIToolbar()

    private func setup() {
        self.addSubview(scrollView)
        scrollView.addSubview(toolbar)
        scrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clearColor()
        toolbar.autoresizingMask = .FlexibleWidth
        var items: [UIBarButtonItem] = []
        for t in ButtonTag.all {
            let item = UIBarButtonItem(title: t.iconName, style: .Bordered, target: self, action:  #selector(Toolbar.toolbarButtonTapped(_:)))
            item.tag = t.rawValue
            items.append(item)
        }
        self.toolbarItems = items
    }

    @objc private func toolbarButtonTapped(item: AnyObject?) {
        if let item = item as? UIBarButtonItem, tag = ButtonTag(rawValue: item.tag) {
            self.editor?.toolbarButtonTapped(tag, item)
        }
    }

    public var toolbarItems: [UIBarButtonItem] = [] {
        didSet {
            self.toolbar.items = toolbarItems
            self.setNeedsLayout()
        }
    }

    internal var editor: SwiftyDraft?

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        toolbar.backgroundColor = UIColor.redColor()
        let b = self.bounds
        toolbar.frame = CGRect(x: 0, y: 0, width: 200 * CGFloat(self.toolbarItems.count) , height: b.height)
        scrollView.frame = CGRect(origin: CGPointZero, size: b.size)
        scrollView.contentSize = toolbar.frame.size
    }
}
