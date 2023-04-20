//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public extension UIView {

    func makeConstraints(_ closure: (_ make: LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }

    func makeConstraints(in superview: UIView, with insets: UIEdgeInsets = .zero) {
        superview.addSubview(self)
        makeConstraints { proxy in
            proxy.bottom.equalTo(superview.bottomAnchor).offset(-insets.bottom)
            proxy.top.equalTo(superview.topAnchor).offset(insets.top)
            proxy.leading.equalTo(superview.leadingAnchor).offset(insets.left)
            proxy.trailing.equalTo(superview.trailingAnchor).offset(-insets.right)
        }
    }
}

extension UIView {
    var layoutProxy: LayoutProxy {
        return LayoutProxy(view: self)
    }
}

public extension UIView {
    var prx: Constraint {
        return Constraint(view: self)
    }
}

public extension UIView {

    private struct AssociatedKeys {
        static var layout = "layout"
    }

    var layout: Layout {
        get {
            var layout: Layout!
            let lookup = objc_getAssociatedObject(self, &AssociatedKeys.layout) as? Layout
            if let lookup = lookup {
                layout = lookup
            } else {
                let newLayout = Layout()
                self.layout = newLayout
                layout = newLayout
            }
            return layout
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.layout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
