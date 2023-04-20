//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

public final class Constraint {
    public lazy var leading = property(with: view.leadingAnchor, kind: .leading).anchor
    public lazy var trailing = property(with: view.trailingAnchor, kind: .trailing).anchor
    public lazy var top = property(with: view.topAnchor, kind: .top).anchor
    public lazy var bottom = property(with: view.bottomAnchor, kind: .bottom).anchor
    public lazy var centerX = property(with: view.centerXAnchor, kind: .centerX).anchor
    public lazy var centerY = property(with: view.centerYAnchor, kind: .centerY).anchor
    public lazy var width = attribute(with: view.widthAnchor, kind: .width).anchor
    public lazy var height = attribute(with: view.heightAnchor, kind: .height).anchor

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
