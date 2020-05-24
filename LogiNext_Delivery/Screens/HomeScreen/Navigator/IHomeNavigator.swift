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
    var logisticViewModel: LogisticViewModel {get}
    func showCreateUserScreen()
    func createNewOrder()
}

class HomeNavigator: IHomeNavigator {
    
    var navigation: UINavigationController?
    var logisticViewModel: LogisticViewModel {
        return LogisticViewModel()
    }
    
    required init(nav: UINavigationController?) {
        self.navigation = nav
    }
    
    func showCreateUserScreen() {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Main, initialViewControllerIdentifier: UserListViewController.storyBoardID) as? UserListViewController {
            vc.viewModel = UserListViewModel(logistics: logisticViewModel)
            //
            navigation?.present(vc, animated: true, completion: {
                
            })
        }
    }
    
    func createNewOrder() {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Order, initialViewControllerIdentifier: OrderDetailViewController .storyBoardID) as? OrderDetailViewController {
            vc.viewModel = OrderDetailViewModel(logistics: logisticViewModel, order: nil)
            navigation?.pushViewController(vc, animated: true)
        }
    }
}

