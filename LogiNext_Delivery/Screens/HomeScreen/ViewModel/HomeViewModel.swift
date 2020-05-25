//
//  OrderListViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 24/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class HomeViewModel {
    var logisiticsMainViewModel: LogisticViewModel?
    fileprivate(set) var allOrders = [OrderDTO]()
    fileprivate(set) var tabHeadings = [String]()
    var reloadBlock: (() -> Void)?
    
    init(logistics: LogisticViewModel) {
        self.logisiticsMainViewModel = logistics
        getTabHeadings()
    }
    
    func getTabHeadings() {
        let titles = OrderTabs.allCases.map {
            $0.getTitle(count: 0)
        }
        self.tabHeadings = titles
    }
    
    func getAllOrdersList() {
        self.logisiticsMainViewModel?.getAllOrders(completion: { (orderDTOs) in
            if let array = orderDTOs {
                self.allOrders = array
            }
            self.reloadBlock?()
        })
    }
    
    func loadOrdersAsPerTabIndex(index: Int) {
        let tabValue = OrderTabs.valueAtIndex(index: index)
        //var predicate: NSPredicate?
        if tabValue == .All {
            self.getAllOrdersList()
        } else if tabValue == .MyOrders  {
            guard let id = self.logisiticsMainViewModel?.currentUser?.userId else {return}
            let predicate = NSPredicate(format: "%K == %@", argumentArray: ["createdByUser.userId", id])
            self.logisiticsMainViewModel?.getOrdersFor(predicate: predicate, completion: { (dtos) in
                self.allOrders = dtos ?? []
                self.reloadBlock?()
            })
        }
        
    }
}
