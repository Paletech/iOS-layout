//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public protocol LayoutDimension: AnyObject, LayoutAnchor {
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutDimension: LayoutDimension {}
