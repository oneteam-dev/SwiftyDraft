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

    let scrollView = UIScrollView()
    let toolbar = UIToolbar()
    let closeButton = UIButton(type: .Custom)
    let openButton = UIButton(type: .Custom)
    var opened = true {
        didSet {
            setNeedsLayout()
        }
    }

    private func setup() {
        addSubview(scrollView)
        addSubview(closeButton)
        addSubview(openButton)
        let unselectedTintColor = UIColor(white: 0.8, alpha: 1.0)
        let borderColor = UIColor(white: 0.95, alpha: 1.0)
        closeButton.addTarget(self, action: #selector(Toolbar.toggleOpened(_:)),
                              forControlEvents: .TouchUpInside)
        openButton.addTarget(self, action: #selector(Toolbar.toggleOpened(_:)),
                              forControlEvents: .TouchUpInside)
        closeButton.setTitle("CL", forState: .Normal)
        openButton.setTitle("OP", forState: .Normal)
        closeButton.setTitleColor(unselectedTintColor, forState: .Normal)
        openButton.setTitleColor(unselectedTintColor, forState: .Normal)
        closeButton.backgroundColor = UIColor.whiteColor()
        openButton.backgroundColor = UIColor.whiteColor()
        var borderLeft = CALayer()
        borderLeft.backgroundColor = borderColor.CGColor
        borderLeft.frame = CGRect(x: 0, y: 0, width: 1, height: 9999)
        closeButton.layer.addSublayer(borderLeft)
        borderLeft = CALayer()
        borderLeft.backgroundColor = borderColor.CGColor
        borderLeft.frame = CGRect(x: 0, y: 0, width: 1, height: 9999)
        openButton.layer.addSublayer(borderLeft)
        scrollView.addSubview(toolbar)
        scrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clearColor()
        toolbar.autoresizingMask = .FlexibleWidth
        toolbar.barTintColor = UIColor.whiteColor()
        toolbar.backgroundColor = UIColor.clearColor()
        let borderTop = CALayer()
        borderTop.backgroundColor = borderColor.CGColor
        borderTop.frame = CGRect(x: 0, y: 0, width: 9999, height: 1.0)
        layer.addSublayer(borderTop)
        var items: [UIBarButtonItem] = []
        for t in ButtonTag.all {
            let item = UIBarButtonItem(
                title: t.iconName, style: .Bordered,
                target: self, action:  #selector(Toolbar.toolbarButtonTapped(_:)))
            item.tag = t.rawValue
            item.tintColor = unselectedTintColor
            items.append(item)
        }
        toolbarItems = items
    }

    @objc private func toggleOpened(item: AnyObject?) {
        opened = !opened
        if opened {
            editor?.focus()
        } else {
            editor?.blur()
        }
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
        let b = self.bounds
        toolbar.frame = CGRect(x: 0, y: 0, width: 200 * CGFloat(self.toolbarItems.count) , height: b.height)
        scrollView.frame = CGRect(origin: CGPointZero, size: b.size)
        scrollView.contentSize = toolbar.frame.size
        let closeButtonWidth: CGFloat = 44
        let f = CGRect(x: b.width - closeButtonWidth, y: 0, width: closeButtonWidth, height: b.height)
        closeButton.frame = f
        openButton.frame = f
        openButton.hidden = opened
        closeButton.hidden = !opened
    }
}
