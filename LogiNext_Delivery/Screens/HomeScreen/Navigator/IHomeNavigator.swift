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
    func showOrderDetailScreen(orderDTO: OrderDTO)
    var userUpdated: (() -> Void)? { get set }
    var orderUpdated: (() -> Void)? { get set }
}

class HomeNavigator: IHomeNavigator {
    
    var navigation: UINavigationController?
    var logisticViewModel: LogisticViewModel
    
    var orderUpdated: (() -> Void)?
    var userUpdated: (() -> Void)?
    
    required init(nav: UINavigationController?) {
        self.navigation = nav
        logisticViewModel = LogisticViewModel()
    }
    
    func showCreateUserScreen() {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Main, initialViewControllerIdentifier: UserListViewController.storyBoardID) as? UserListViewController {
            vc.viewModel = UserListViewModel(logistics: logisticViewModel)
            vc.viewModel?.navigator = self
            navigation?.present(vc, animated: true, completion: {
                
            })
        }
    }
    
    func createNewOrder() {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Order, initialViewControllerIdentifier: OrderDetailViewController .storyBoardID) as? OrderDetailViewController {
            vc.viewModel = OrderDetailViewModel(logistics: logisticViewModel, order: nil)
            vc.viewModel?.navigator = self
            navigation?.pushViewController(vc, animated: true)
        }
    }
    
    func showOrderDetailScreen(orderDTO: OrderDTO) {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Order, initialViewControllerIdentifier: OrderDetailViewController.storyBoardID) as? OrderDetailViewController {
            vc.viewModel = OrderDetailViewModel(logistics: logisticViewModel, order: orderDTO)
            vc.viewModel?.navigator = self
            navigation?.pushViewController(vc, animated: true)
        }
    }
}

