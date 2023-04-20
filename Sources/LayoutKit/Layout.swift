//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public final class Layout: NSObject {

    weak var top: NSLayoutConstraint?
    weak var bottom: NSLayoutConstraint?
    weak var leading: NSLayoutConstraint?
    weak var trailing: NSLayoutConstraint?
    weak var centerX: NSLayoutConstraint?
    weak var centerY: NSLayoutConstraint?
    weak var width: NSLayoutConstraint?
    weak var height: NSLayoutConstraint?

    func update<A: LayoutAnchor>(constraint: NSLayoutConstraint, kind: LayoutProperty<A>.Kind) {
        switch kind {
        case .top: top = constraint
        case .bottom: bottom = constraint
        case .leading: leading = constraint
        case .trailing: trailing = constraint
        case .centerX: centerX = constraint
        case .centerY: centerY = constraint
        case .width: width = constraint
        case .height: height = constraint
        }
    }
}
