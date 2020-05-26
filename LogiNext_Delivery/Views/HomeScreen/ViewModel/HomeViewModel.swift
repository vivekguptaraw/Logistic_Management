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
    var selectedTabIndex: Int = 0
    
    init(logistics: LogisticViewModel) {
        self.logisiticsMainViewModel = logistics
        getTabHeadings()
    }
    
    func getTabHeadings() {
        var tabs = [String]()
//        let titles = OrderTabs.allCases.map {
//
//            $0.getTitle(count: 0)
//        }
        OrderTabs.allCases.forEach { (t) in
            if let index = t.index, index == selectedTabIndex {
                tabs.append(t.getTitle(count: self.allOrders.count))
            } else {
                tabs.append(t.getTitle(count: nil))
            }
        }
        self.tabHeadings.removeAll()
        self.tabHeadings = tabs
    }
    
    func getAllOrdersList() {
        let sorted = Sorted(key: "lastUpdatedDate", ascending: false)
        self.logisiticsMainViewModel?.getAllOrders(sorted: sorted, completion: { (orderDTOs) in
            if let array = orderDTOs {
                self.allOrders = array
            }
            self.getTabHeadings()
            self.reloadBlock?()
        })
    }
    
    func loadOrdersAsPerTabIndex(index: Int) {
        let tabValue = OrderTabs.valueAtIndex(index: index)
        var comp: NSCompoundPredicate?
        var userPredicate: NSPredicate?
        let sorted = Sorted(key: "lastUpdatedDate", ascending: false)
        if tabValue.isForCurrentUser {
            guard let id = self.logisiticsMainViewModel?.currentUser?.userId else {return}
            userPredicate = NSPredicate(format: "%K == %@", argumentArray: ["createdByUser.userId", id])
        }
        if tabValue == .MyAllOrders || tabValue == .All  {
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate!])
            }
        } else if tabValue == .MyToday || tabValue == .AllToday {
            let predicateDate = NSPredicate(format: "%K >= %@", argumentArray: ["createdDate", Date.midnight])
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDate, userPredicate!])
            } else {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDate])
            }
        } else if tabValue == .MyQueued || tabValue == .AllQueued {
            let predicate1 = NSPredicate(format: "%K == %@", argumentArray: ["isInTransit", false])
            let predicate2 = NSPredicate(format: "%K == %@", argumentArray: ["isDelivered", false])
            let predicate3 = NSPredicate(format: "%K == %@", argumentArray: ["isCancelled", false])
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, userPredicate!])
            } else {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
            }
        } else if tabValue == .MyInTransit || tabValue == .AllInTransit {
            let predicate1 = NSPredicate(format: "%K == %@", argumentArray: ["isInTransit", true])
            let predicate2 = NSPredicate(format: "%K == %@", argumentArray: ["isCancelled", false])
            let predicate3 = NSPredicate(format: "%K == %@", argumentArray: ["isDelivered", false])
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, userPredicate!])
            } else {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
            }
            
        } else if tabValue == .MyDelivered || tabValue == .AllDelivered {
            let predicate2 = NSPredicate(format: "%K == %@", argumentArray: ["isDelivered", true])
            let predicate3 = NSPredicate(format: "%K == %@", argumentArray: ["isCancelled", false])
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate2, predicate3, userPredicate!])
            } else {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate2, predicate3])
            }
        } else if tabValue == .MyCancelled || tabValue == .AllCancelled {
            let predicate1 = NSPredicate(format: "%K == %@", argumentArray: ["isCancelled", true])
            if tabValue.isForCurrentUser {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, userPredicate!])
            } else {
                comp = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
            }
        }
        self.logisiticsMainViewModel?.getOrdersFor(predicate: comp, sorted: sorted, completion: { (dtos) in
            self.allOrders = dtos ?? []
            self.getTabHeadings()
            self.reloadBlock?()
        })
    }
}
