//
//  Toolbar.swift
//  Pods
//
//  Created by Atsushi Nagase on 5/4/16.
//
//

import UIKit

public class Toolbar: UIView {

    let scrollView = UIScrollView()
    let toolbar = UIToolbar()
    let closeButton = UIButton(type: .Custom)
    let openButton = UIButton(type: .Custom)
    var opened = true {
        didSet {
            setNeedsLayout()
        }
    }

    var headingLevel: Int = 1 {
        didSet {
            self.updateToolbarItems()
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
        closeButton.tintColor = unselectedTintColor
        openButton.tintColor = unselectedTintColor
        var img = UIImage(named: "toolbar-icon-close",
            inBundle: SwiftyDraft.resourceBundle, compatibleWithTraitCollection: nil)?
            .imageWithRenderingMode(.AlwaysTemplate)
        closeButton.setImage(img, forState: .Normal)
        closeButton.setImage(img, forState: .Highlighted)
        img = UIImage(named: "toolbar-icon-open",
            inBundle: SwiftyDraft.resourceBundle, compatibleWithTraitCollection: nil)?
            .imageWithRenderingMode(.AlwaysTemplate)
        openButton.setImage(img, forState: .Normal)
        openButton.setImage(img, forState: .Highlighted)
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
                image: t.iconImage, style: .Plain,
                target: self, action:  #selector(Toolbar.toolbarButtonTapped(_:)))
            item.tag = t.rawValue
            item.tintColor = unselectedTintColor
            items.append(item)
        }
        toolbarItems = items
    }

    private func updateToolbarItems() {
        // FIXME
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
        let closeButtonWidth: CGFloat = 44
        let toolbarWidth: CGFloat = self.toolbarItems.reduce(0) { sofar, item in
            var w = (item.valueForKey("view") as? UIView)?.bounds.width ?? 22.0
            return sofar + w + 11.0
        } + 55
        let toolbarSize = CGSize(width: toolbarWidth, height: 44)
        toolbar.frame = CGRect(origin: CGPointZero, size: toolbarSize)
        scrollView.frame = CGRect(origin: CGPointZero, size: b.size)
        scrollView.contentSize = toolbarSize
        let f = CGRect(x: b.width - closeButtonWidth, y: 0, width: closeButtonWidth, height: 44)
        closeButton.frame = f
        openButton.frame = f
        openButton.hidden = opened
        closeButton.hidden = !opened
    }
}
