import UIKit

public protocol LayoutDimension: AnyObject, LayoutAnchor {
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint
}

public protocol LayoutAnchor: AnyObject {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutDimension: LayoutDimension {}
extension NSLayoutAnchor: LayoutAnchor {}

public class LayoutProperty<Anchor: LayoutAnchor> {
    
    fileprivate let anchor: Anchor
    fileprivate let view: UIView
    fileprivate let kind: Kind
    fileprivate var constraint: NSLayoutConstraint?
    
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

public class LayoutAttribute<Dimension: LayoutDimension>: LayoutProperty<Dimension> {
    
    fileprivate let dimension: Dimension
    
    init(dimension: Dimension, view: UIView, kind: Kind) {
        self.dimension = dimension
        
        super.init(anchor: dimension, view: view, kind: kind)
    }
}

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
    
    fileprivate init(view: UIView) {
        self.view = view
    }

    private func property<A: LayoutAnchor>(with anchor: A, kind: LayoutProperty<A>.Kind) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor, view: view, kind: kind)
    }
    
    private func attribute<D: LayoutDimension>(with dimension: D, kind: LayoutProperty<D>.Kind) -> LayoutAttribute<D> {
        return LayoutAttribute(dimension: dimension, view: view, kind: kind)
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

public final class Layout: NSObject {
    
    weak var top: NSLayoutConstraint?
    weak var bottom: NSLayoutConstraint?
    weak var leading: NSLayoutConstraint?
    weak var trailing: NSLayoutConstraint?
    weak var centerX: NSLayoutConstraint?
    weak var centerY: NSLayoutConstraint?
    weak var width: NSLayoutConstraint?
    weak var height: NSLayoutConstraint?
    
    fileprivate func update<A: LayoutAnchor>(constraint: NSLayoutConstraint, kind: LayoutProperty<A>.Kind) {
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
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    private func property<A: LayoutAnchor>(with anchor: A, kind: LayoutProperty<A>.Kind) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor, view: view, kind: kind)
    }
    
    private func attribute<D: LayoutDimension>(with dimension: D, kind: LayoutProperty<D>.Kind) -> LayoutAttribute<D> {
        return LayoutAttribute(dimension: dimension, view: view, kind: kind)
    }
}
