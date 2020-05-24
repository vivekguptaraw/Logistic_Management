//
//  UIView+Additions.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol TapGestureNeeded: class {}

var event: UInt8 = 0
extension TapGestureNeeded where Self: UIView {
    var onClickEvent: (() -> Swift.Void)? {
        set {
            objc_setAssociatedObject(self, &event, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &event) as? (() -> Swift.Void)
        }
    }
    
    func addTapGesture(onClick: (() -> Swift.Void)? = nil) {
        self.gestureRecognizers                 = nil
        self.onClickEvent                       = onClick
        self.isUserInteractionEnabled           = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        self.addGestureRecognizer(tapGesture)
    }
}

extension UIView: TapGestureNeeded {
    @objc func screenTapped() {
        if let eventClick = self.onClickEvent {
            eventClick()
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundedCornerAll(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, extraPadding: CGFloat = 0) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: bounds.minX, y: bounds.minY + extraPadding, width: bounds.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: bounds.minX, y: bounds.maxY - thickness, width: bounds.width, height: thickness)
        }
        if layer.position.x != CGFloat.nan && layer.position.x != CGFloat.signalingNaN && layer.position.y != CGFloat.nan && layer.position.y != CGFloat.signalingNaN {
            if border.position.x != CGFloat.nan && border.position.x != CGFloat.signalingNaN && border.position.y != CGFloat.nan && border.position.y != CGFloat.signalingNaN {
                layer.addSublayer(border)
            }
        }
    }
}
