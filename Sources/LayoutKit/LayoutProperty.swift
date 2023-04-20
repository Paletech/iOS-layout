//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public class LayoutProperty<Anchor: LayoutAnchor> {

    let anchor: Anchor
    let view: UIView
    let kind: Kind
    var constraint: NSLayoutConstraint?

    public enum Kind { case leading, trailing, top, bottom, centerX, centerY, width, height }

    init(anchor: Anchor, view: UIView, kind: Kind) {
        self.anchor = anchor
        self.view = view
        self.kind = kind
    }

    @discardableResult
    public func offset(_ constant: CGFloat) -> NSLayoutConstraint {
        guard let constraint = constraint else { return NSLayoutConstraint() }
        constraint.constant = constant
        return constraint
    }
}

public extension LayoutProperty {

    @discardableResult
    func equalTo(_ otherAnchor: Anchor, priority: UILayoutPriority? = nil, multiplier: CGFloat? = nil) -> LayoutProperty {
        var constraint = anchor.constraint(equalTo: otherAnchor, constant: 0)

        if let multiplier = multiplier {
            constraint = constraint.constraintWithMultiplier(multiplier)
        }

        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)

        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        self.constraint = constraint
        return self
    }

    @discardableResult
    func greaterThanOrEqualTo(_ otherAnchor: Anchor, offsetBy constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func lessThanOrEqualTo(_ otherAnchor: Anchor, offsetBy constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }
}

public extension LayoutProperty {

    @discardableResult
    func equalToSuperview(priority: UILayoutPriority? = nil, multiplier: CGFloat? = nil) -> LayoutProperty {
         guard let superview = view.superview,
               let otherAnchor = superview.layoutProxy.anchor(for: kind) else {
             fatalError("Superview not found")
         }
         return equalTo(otherAnchor, priority: priority, multiplier: multiplier)
     }
}
