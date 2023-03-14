//
//  AutoLayout.swift
//  Finale To Do
//
//  Created by Grant Oganyan on 1/11/23.
//

import Foundation
import UIKit

/// Represents a single `NSLayoutConstraint`
enum LayoutAnchor {
    case constant(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  constant: CGFloat)

    case relative(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  relatedTo: NSLayoutConstraint.Attribute,
                  multiplier: CGFloat,
                  constant: CGFloat)
    
    case relativeTo(view: UIView,
                    attribute: NSLayoutConstraint.Attribute,
                    relation: NSLayoutConstraint.Relation,
                    relatedTo: NSLayoutConstraint.Attribute,
                    multiplier: CGFloat,
                    constant: CGFloat)
    
    case aspectRatio(widthToHeight: CGFloat)
    
    case safeArea (attribute: NSLayoutConstraint.Attribute,
                   relation: NSLayoutConstraint.Relation,
                   relatedTo: NSLayoutConstraint.Attribute,
                   constant: CGFloat)
    case keyboard (attribute: NSLayoutConstraint.Attribute,
                   relation: NSLayoutConstraint.Relation,
                   relatedTo: NSLayoutConstraint.Attribute,
                   constant: CGFloat)
}

// MARK: - Factory methods
extension LayoutAnchor {
    static let fullFrame: [LayoutAnchor] = fullFrame(0)
    static func fullFrame (_ padding: CGFloat) -> [LayoutAnchor] {
        return [.leading(padding), .trailing(padding), .top(padding), .bottom(padding)]
    }
    
    static let leading = relative(attribute: .leading, relation: .equal, relatedTo: .leading)
    static let trailing = relative(attribute: .trailing, relation: .equal, relatedTo: .trailing, invertConstant: true)
    static let top = relative(attribute: .top, relation: .equal, relatedTo: .top)
    static let bottom = relative(attribute: .bottom, relation: .equal, relatedTo: .bottom, invertConstant: true)

    static let centerX = relative(attribute: .centerX, relation: .equal, relatedTo: .centerX)
    static let centerY = relative(attribute: .centerY, relation: .equal, relatedTo: .centerY)
    
    static let centerXMultiplier = relativeMultiplier(attribute: .centerX, relation: .equal, relatedTo: .centerX)
    static let centerYMultiplier = relativeMultiplier(attribute: .centerY, relation: .equal, relatedTo: .centerY)

    static let width = constant(attribute: .width, relation: .equal)
    static let height = constant(attribute: .height, relation: .equal)
    
    static let heightMultiplier = relativeMultiplier(attribute: .height, relation: .equal, relatedTo: .height)
    static let widthMultiplier = relativeMultiplier(attribute: .width, relation: .equal, relatedTo: .width)
    
    static let topToBottom = relativeTo(attribute: .top, relation: .equal, relatedTo: .bottom)
    static let topToTop = relativeTo(attribute: .top, relation: .equal, relatedTo: .top)
    static let bottomToBottom = relativeTo(attribute: .bottom, relation: .equal, relatedTo: .bottom, invertConstant: true)
    static let bottomToTop = relativeTo(attribute: .bottom, relation: .equal, relatedTo: .top, invertConstant: true)
    static let trailingToLeading = relativeTo(attribute: .trailing, relation: .equal, relatedTo: .leading, invertConstant: true)
    static let trailingToTrailing = relativeTo(attribute: .trailing, relation: .equal, relatedTo: .trailing, invertConstant: true)
    static let leadingToTrailing = relativeTo(attribute: .leading, relation: .equal, relatedTo: .trailing, invertConstant: false)
    static let leadingToLeading = relativeTo(attribute: .leading, relation: .equal, relatedTo: .leading, invertConstant: false)
    
    static let centerYtoCenterY = relativeTo(attribute: .centerY, relation: .equal, relatedTo: .centerY)
    static let centerXtoCenterX = relativeTo(attribute: .centerX, relation: .equal, relatedTo: .centerX)
    
    static let widthToWidth = relativeTo(attribute: .width, relation: .equal, relatedTo: .width)
    static let heightToHeight = relativeTo(attribute: .height, relation: .equal, relatedTo: .height)
    
    static let widthToWidthMultiplier = relativeToMultiplier(attribute: .width, relation: .equal, relatedTo: .width)
    static let heightToHeightMultiplier = relativeToMultiplier(attribute: .height, relation: .equal, relatedTo: .height)
    
    static let safeAreaBottom = safeArea(attribute: .bottom, relation: .equal, relatedTo: .bottom, invertConstant: true)
    static let safeAreaTop = safeArea(attribute: .top, relation: .equal, relatedTo: .top)
    static let safeAreaLeading = safeArea(attribute: .leading, relation: .equal, relatedTo: .leading)
    static let safeAreaTrailing = safeArea(attribute: .trailing, relation: .equal, relatedTo: .trailing, invertConstant: true)
    
    static let bottomToKeyboardTop = keyboard(attribute: .bottom, relation: .equal, relatedTo: .top, invertConstant: true)
    
    static func constant(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation
    ) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .constant(attribute: attribute, relation: relation, constant: constant)
        }
    }

    static func relative(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, invertConstant: Bool = false) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .relative(attribute: attribute, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: invertConstant ? -constant : constant)
        }
    }
    
    static func relativeMultiplier(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute) -> (CGFloat) -> LayoutAnchor {
        return { multiplier in
            .relative(attribute: attribute, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: 0)
        }
    }
    
    static func relativeTo(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, invertConstant: Bool = false) -> (UIView, CGFloat) -> LayoutAnchor {
        return { view, constant in
            .relativeTo(view: view, attribute: attribute, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: invertConstant ? -constant : constant)
        }
    }
    
    static func relativeToMultiplier(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute) -> (UIView, CGFloat) -> LayoutAnchor {
        return { view, multiplier in
            .relativeTo(view: view, attribute: attribute, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: 0)
        }
    }
    
    static func safeArea(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute, invertConstant: Bool = false) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .safeArea(attribute: attribute, relation: relation, relatedTo: relatedTo, constant: invertConstant ? -constant : constant)
        }
    }
    
    static func keyboard(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, relatedTo: NSLayoutConstraint.Attribute, invertConstant: Bool = false) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .keyboard(attribute: attribute, relation: relation, relatedTo: relatedTo, constant: invertConstant ? -constant : constant)
        }
    }
}

// MARK: - Conveniences
extension UIView {
    func addSubview(_ subview: UIView, anchors: [LayoutAnchor]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.activate(anchors: anchors, relativeTo: self)
    }

    func activate(anchors: [LayoutAnchor], relativeTo item: UIView? = nil) {
        let constraints = anchors.map { NSLayoutConstraint(from: self, to: item, anchor: $0) }
        NSLayoutConstraint.activate(constraints)
    }
    
    func sizeConstraints(_ size: CGSize) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    func setupLayoutGuide (top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil) -> UILayoutGuide {
        let lg = UILayoutGuide()
        self.addLayoutGuide(lg)
        
        if let top = top { lg.topAnchor.constraint(equalTo: top).isActive = true }
        if let bottom = bottom { lg.bottomAnchor.constraint(equalTo: bottom).isActive = true }
        if let leading = leading { lg.leadingAnchor.constraint(equalTo: leading).isActive = true }
        if let trailing = trailing { lg.trailingAnchor.constraint(equalTo: trailing).isActive = true }
        
        return lg
    }
}

extension NSLayoutConstraint {
    
    convenience init(from: UIView, to item: UIView?, anchor: LayoutAnchor) {
        switch anchor {
        case let .constant(attribute: attr, relation: relation, constant: constant):
            self.init(item: from, attribute: attr, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
            
        case let .relative(attribute: attr, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: constant):
            self.init(item: from, attribute: attr, relatedBy: relation, toItem: item, attribute: relatedTo, multiplier: multiplier, constant: constant)
            
        case let .relativeTo(view: view, attribute: attr, relation: relation, relatedTo: relatedTo, multiplier: multiplier, constant: constant):
            self.init(item: from, attribute: attr, relatedBy: relation, toItem: view, attribute: relatedTo, multiplier: multiplier, constant: constant)
            
        case let .aspectRatio(widthToHeight: ratio):
            self.init(item: from, attribute: .width, relatedBy: .equal, toItem: from, attribute: .height, multiplier: ratio, constant: 0)
            
        case let .safeArea(attribute: attr, relation: relation, relatedTo: relatedTo, constant: constant):
            self.init(item: from, attribute: attr, relatedBy: relation, toItem: item?.safeAreaLayoutGuide, attribute: relatedTo, multiplier: 1, constant: constant)
        
        case let .keyboard(attribute: attr, relation: relation, relatedTo: relatedTo, constant: constant):
            if #available(iOS 15.0, *) {
                self.init(item: from, attribute: attr, relatedBy: relation, toItem: item?.keyboardLayoutGuide, attribute: relatedTo, multiplier: 1, constant: constant)
            } else {
                self.init(item: from, attribute: attr, relatedBy: relation, toItem: item?.safeAreaLayoutGuide, attribute: relatedTo, multiplier: 1, constant: constant)
            }
        }
    }
}
