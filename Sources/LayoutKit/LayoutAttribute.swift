//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public class LayoutAttribute<Dimension: LayoutDimension>: LayoutProperty<Dimension> {
    
    let dimension: Dimension
    
    init(dimension: Dimension, view: UIView, kind: Kind) {
        self.dimension = dimension
        
        super.init(anchor: dimension, view: view, kind: kind)
    }
}

public extension LayoutAttribute {
    @discardableResult
    func equalTo(_ constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimension.constraint(equalToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func greaterThanOrEqualTo(_ constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func lessThanOrEqualTo(_ constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func equalTo(_ otherDimension: Dimension, multiplier: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = dimension.constraint(equalTo: otherDimension, multiplier: multiplier)
        (constraint.firstItem as? UIView)?.layout.update(constraint: constraint, kind: kind)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }
}
