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
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
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
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }

}
