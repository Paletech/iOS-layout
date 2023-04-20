//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 20.04.2023.
//

import UIKit

func +<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

func -<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

@discardableResult
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: ((A, CGFloat), UILayoutPriority)) -> NSLayoutConstraint {
    let constraint = lhs.equalTo(rhs.0.0, priority: rhs.1).offset(rhs.0.1)
    constraint.isActive = true
    return constraint
}

@discardableResult
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, UILayoutPriority)) -> NSLayoutConstraint {
    guard let constraint = lhs.equalTo(rhs.0, priority: rhs.1).constraint else {
        fatalError("Constraint is nil")
    }
    return constraint
}

@discardableResult
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: LayoutProperty<A>) -> NSLayoutConstraint {
    let constraint = lhs.equalTo(rhs.anchor).constraint
    constraint?.isActive = true
    return constraint!
}

@discardableResult
func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    guard let constraint = lhs.equalTo(rhs).constraint else {
        fatalError("Constraint is nil")
    }
    return constraint
}

@discardableResult
func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqualTo(rhs.0, offsetBy: rhs.1)
}

@discardableResult
func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqualTo(rhs)
}

@discardableResult
func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.lessThanOrEqualTo(rhs.0, offsetBy: rhs.1)
}

@discardableResult
func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.lessThanOrEqualTo(rhs)
}

@discardableResult
func <=<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.lessThanOrEqualTo(rhs)
}

@discardableResult
func ==<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.equalTo(rhs)
}

@discardableResult
func ==<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: (CGFloat, UILayoutPriority)) -> NSLayoutConstraint {
    return lhs.equalTo(rhs.0, priority: rhs.1)
}

@discardableResult
func ==<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: LayoutAttribute<D>) -> NSLayoutConstraint {
    guard let constraint = lhs.equalTo(rhs.dimension).constraint else {
        fatalError("Constraint is nil")
    }
    return constraint
}

@discardableResult
func *=<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: (LayoutAttribute<D>, CGFloat, UILayoutPriority)) -> NSLayoutConstraint {
    return lhs.equalTo(rhs.0.dimension, multiplier: rhs.1, priority: rhs.2)
}

@discardableResult
func >=<D: LayoutDimension>(lhs: LayoutAttribute<D>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.greaterThanOrEqualTo(rhs)
}

