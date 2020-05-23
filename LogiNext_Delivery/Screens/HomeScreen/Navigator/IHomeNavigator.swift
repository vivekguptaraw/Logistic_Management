//
//  IHomeNavigator.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol IHomeNavigator {
    init(nav: UINavigationController?)
    func showCreateUserScreen()
}

class HomeNavigator: IHomeNavigator {
    var navigation: UINavigationController?
    let vm = LogisticViewModel()
    required init(nav: UINavigationController?) {
        self.navigation = nav
    }
    
    func showCreateUserScreen() {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Main, initialViewControllerIdentifier: UserListViewController.storyBoardID) as? UserListViewController {
            vc.viewModel = UserListViewModel(logistics: vm)
            //
            navigation?.present(vc, animated: true, completion: {
                
            })
        }
    }
}

