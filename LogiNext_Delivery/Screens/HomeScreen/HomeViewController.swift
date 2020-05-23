//
//  HomeViewController.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var navigator: IHomeNavigator?
    @IBOutlet weak var menuBottomY: NSLayoutConstraint!
    
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    var menuTap: UITapGestureRecognizer?
    var isMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBottomY.constant = -(self.userButton.frame.height + 20)
        navigator = HomeNavigator(nav: self.navigationController)
        setUIElements()
    }
    
    func setUIElements() {
        menuTap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        plusImageView.addGestureRecognizer(menuTap!)
    }
    
    @objc func menuTapped() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
            self.menuBottomY.constant = self.isMenuOpen ? -(self.userButton.frame.height + 20) : 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.isMenuOpen = !self.isMenuOpen
        }
    }
    
    @IBAction func userButtonClick(_ sender: Any) {
        menuTapped()
        self.navigator?.showCreateUserScreen()
    }
    
    @IBAction func orderButtonClick(_ sender: Any) {
    }
    
}


extension HomeViewController {
    
}

