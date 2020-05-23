//
//  UIViewController+Additions.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit


protocol StoryBoardID: class {}

extension StoryBoardID where Self: UIViewController {
    static var storyBoardID: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryBoardID {
    
}
