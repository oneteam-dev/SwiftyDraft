//
//  WKWebViewExtension.swift
//
//  Created by Robots & Pencils on 2016-03-10.
//  https://robotsandpencils.com/swift-swizzling-adding-a-custom-toolbar-to-wkwebview/
//

import Foundation
import WebKit

private var ToolbarHandle: UInt8 = 0

extension WKWebView {

    var contentView: UIView? {
        var candidateView: UIView? = nil
        for view in self.scrollView.subviews {
            if String(view.dynamicType).hasPrefix("WKContent") {
                candidateView = view
            }
        }
        return candidateView
    }

    func addRichEditorInputAccessoryView(toolbar: UIView?) {
        guard let toolbar = toolbar else { return }
        objc_setAssociatedObject(self, &ToolbarHandle, toolbar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        guard let targetView = self.contentView else { return }
        let newClass: AnyClass? = classWithCustomAccessoryView(targetView)
        object_setClass(targetView, newClass)
    }

    private func classWithCustomAccessoryView(targetView: UIView) -> AnyClass? {
        guard let targetSuperClass = targetView.superclass else { return nil }
        let customInputAccessoryViewClassName = "\(targetSuperClass)_CustomInputAccessoryView"

        var newClass: AnyClass? = NSClassFromString(customInputAccessoryViewClassName)
        if newClass == nil {
            newClass = objc_allocateClassPair(object_getClass(targetView), customInputAccessoryViewClassName, 0)
        } else {
            return newClass
        }

        let newMethod = class_getInstanceMethod(WKWebView.self, #selector(WKWebView.getCustomInputAccessoryView))
        class_addMethod(newClass.self, Selector("inputAccessoryView"), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))

        objc_registerClassPair(newClass);

        return newClass
    }

    func set_keyboardDisplayRequiresUserAction() {
        contentView?.performSelector("")

    }

    @objc func getCustomInputAccessoryView() -> UIView? {
        var superWebView: UIView? = self
        while (superWebView != nil) && !(superWebView is WKWebView) {
            superWebView = superWebView?.superview
        }
        let customInputAccessory = objc_getAssociatedObject(superWebView, &ToolbarHandle)
        return customInputAccessory as? UIView
    }
    
}