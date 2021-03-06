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
    let closeButton = UIButton(type: .custom)
    let openButton = UIButton(type: .custom)
    var opened = true {
        didSet {
            setNeedsLayout()
        }
    }
    var lineView:UIView?


    var currentInlineStyles = [InlineStyle]() {
        didSet {
            self.updateToolbarItems()
        }
    }

    var currentBlockType = BlockType.Unstyled {
        didSet {
            self.updateToolbarItems()
        }
    }

    var unselectedTintColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet {
            self.updateToolbarItems()
        }
    }

    var selectedTintColor = UIColor(red: 0/255, green: 173/255, blue: 242/255, alpha: 1) {
        didSet {
            self.updateToolbarItems()
        }
    }

    private func setup() {
        addSubview(scrollView)
        // WKWebView does not support userInteractionEnabled
        // addSubview(closeButton)
        // addSubview(openButton)
        backgroundColor = UIColor.white
        let unselectedTintColor = UIColor(white: 0.8, alpha: 1.0)
        let borderColor = UIColor(white: 0.90, alpha: 1.0)
        closeButton.addTarget(self, action: #selector(Toolbar.toggleOpened(_:)),
                              for: .touchUpInside)
        openButton.addTarget(self, action: #selector(Toolbar.toggleOpened(_:)),
                             for: .touchUpInside)
        var img = UIImage(named: "toolbar-icon-close",
            in: SwiftyDraft.resourceBundle, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        closeButton.setImage(img, for: .normal)
        closeButton.setImage(img, for: .highlighted)
        img = UIImage(named: "toolbar-icon-open",
            in: SwiftyDraft.resourceBundle, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        openButton.setImage(img, for: .normal)
        openButton.setImage(img, for: .highlighted)
        closeButton.backgroundColor = UIColor.white
        openButton.backgroundColor = UIColor.white
        var borderLeft = CALayer()
        borderLeft.backgroundColor = borderColor.cgColor
        borderLeft.frame = CGRect(x: 0, y: 0, width: 1, height: 9999)
        closeButton.layer.addSublayer(borderLeft)
        borderLeft = CALayer()
        borderLeft.backgroundColor = borderColor.cgColor
        borderLeft.frame = CGRect(x: 0, y: 0, width: 1, height: 9999)
        openButton.layer.addSublayer(borderLeft)
        scrollView.addSubview(toolbar)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        toolbar.autoresizingMask = .flexibleWidth
        toolbar.barTintColor = UIColor.white
        toolbar.backgroundColor = UIColor.clear
        let borderTop = CALayer()
        borderTop.backgroundColor = UIColor.clear.cgColor
        borderTop.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0)
        layer.addSublayer(borderTop)
        let f = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var items: [UIBarButtonItem] = [f]
        for t in ButtonTag.all {
            switch t {
            case .Space:
                let  item = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                item.width = 63.0
                item.tag = t.rawValue
                item.tintColor = unselectedTintColor
                items.append(item)
                items.append(f)
            default:
                let item = UIBarButtonItem(
                    image: t.iconImage, style: .plain,
                    target: self, action:  #selector(Toolbar.toolbarButtonTapped(_:)))
                item.tag = t.rawValue
                item.tintColor = unselectedTintColor
                items.append(item)
                items.append(f)
            }
        }
        toolbarItems = items
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(Toolbar.handleKeyboardShow(_:)),
                       name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(Toolbar.handleKeyboardHide(_:)),
                       name: UIResponder.keyboardDidHideNotification, object: nil)
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1))
        lineView?.backgroundColor = borderColor
        scrollView.addSubview(lineView!)
    }
    
    private func updateToolbarItems() {
        closeButton.tintColor = unselectedTintColor
        openButton.tintColor = unselectedTintColor
        
        for item in (showedToolbarItems) {
            var selected = false
            if let buttonTag = ButtonTag(rawValue: item.tag) {
                if let blockType = buttonTag.blockType {
                    selected = blockType == self.currentBlockType
                } else if let inlineStyle = buttonTag.inlineStyle {
                    selected = self.currentInlineStyles.contains(inlineStyle)
                }
            }
            item.tintColor = selected ? selectedTintColor : unselectedTintColor
        }
    }

    @objc private func toggleOpened(_ item: AnyObject?) {
        opened = !opened
        if opened {
            editor?.focus()
        } else {
            editor?.blur()
        }
    }

    @objc private func toolbarButtonTapped(_ item: AnyObject?) {
        if let item = item as? UIBarButtonItem, let tag = ButtonTag(rawValue: item.tag) {
            self.editor?.toolbarButtonTapped(tag, item, toolBar:self)
        }
    }

    public var toolbarItems: [UIBarButtonItem] = [] {
        didSet {
            self.toolbar.items = toolbarItems
            self.setNeedsLayout()
            self.updateToolbarItems()
        }
    }
    public var showedToolbarItems: [UIBarButtonItem] = [] {
        didSet {
            self.updateToolbarItems()
        }
    }

    internal var editor: SwiftyDraft?

    // MARK: - Keyboard handling

    @objc func handleKeyboardShow(_ note: Notification) {
        guard let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        self.opened = keyboardSize.height > self.bounds.height
    }

    @objc func handleKeyboardHide(_ note: Notification) {
        self.opened = false
    }

    // MARK: - UIView

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

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
        backgroundColor = UIColor.white
        let b = self.bounds
        let closeButtonWidth: CGFloat = 0 // 54
        let toolbarWidth: CGFloat = self.toolbarItems.reduce(0) { sofar, item in
            let w = (item.value(forKey: "view") as? UIView)?.bounds.width ?? 22.0
            return sofar + w + 11.0
        } + 25 // 75
        toolbar.frame = CGRect(origin: CGPoint.zero,
                               size: CGSize(width: b.size.width, height: 44))
        scrollView.frame = CGRect(origin: CGPoint(x: 0, y: b.height - 44), size: b.size)
        lineView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        let f = CGRect(x: b.width - closeButtonWidth, y: 0, width: closeButtonWidth, height: 44)
        closeButton.frame = f
        openButton.frame = f
        openButton.isHidden = opened
        closeButton.isHidden = !opened
    }
}
