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
            let item = UIBarButtonItem(title: "\(t.rawValue)", style: .Bordered, target: self, action:  #selector(Toolbar.toolbarButtonTapped(_:)))
            items.append(item)
        }
        self.toolbarItems = items
    }

    @objc private func toolbarButtonTapped(item: AnyObject?) {

    }

    public var toolbarItems: [UIBarButtonItem] = [] {
        didSet {
            self.toolbar.items = toolbarItems
            self.setNeedsLayout()
        }
    }

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
        toolbar.frame = CGRect(x: 0, y: 0, width: 50 * CGFloat(self.toolbarItems.count) , height: b.height)
        scrollView.frame = CGRect(origin: CGPointZero, size: b.size)
        scrollView.contentSize = toolbar.frame.size
    }
}
