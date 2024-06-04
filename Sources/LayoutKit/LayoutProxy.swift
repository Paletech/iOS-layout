//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public final class LayoutProxy {
    
    public lazy var leading = property(with: view.leadingAnchor, kind: .leading)
    public lazy var trailing = property(with: view.trailingAnchor, kind: .trailing)
    public lazy var top = property(with: view.topAnchor, kind: .top)
    public lazy var bottom = property(with: view.bottomAnchor, kind: .bottom)
    public lazy var centerX = property(with: view.centerXAnchor, kind: .centerX)
    public lazy var centerY = property(with: view.centerYAnchor, kind: .centerY)
    public lazy var width = attribute(with: view.widthAnchor, kind: .width)
    public lazy var height = attribute(with: view.heightAnchor, kind: .height)
    
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
    }

    private func property<A: LayoutAnchor>(with anchor: A, kind: LayoutProperty<A>.Kind) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor, view: view, kind: kind)
    }
    
    private func attribute<D: LayoutDimension>(with dimension: D, kind: LayoutProperty<D>.Kind) -> LayoutAttribute<D> {
        return LayoutAttribute(dimension: dimension, view: view, kind: kind)
    }
}

public extension LayoutProxy {

    func anchor<A: LayoutAnchor>(for kind: LayoutProperty<A>.Kind) -> A? {
        switch kind {
        case .leading:
            return leading.anchor as? A
        case .trailing:
            return trailing.anchor as? A
        case .top:
            return top.anchor as? A
        case .bottom:
            return bottom.anchor as? A
        case .centerX:
            return centerX.anchor as? A
        case .centerY:
            return centerY.anchor as? A
        case .width, .height:
            return nil
        }
    }
}
