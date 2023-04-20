//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

extension NSLayoutConstraint {

    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: self.firstItem as Any,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: multiplier,
            constant: self.constant
        )
    }
}
