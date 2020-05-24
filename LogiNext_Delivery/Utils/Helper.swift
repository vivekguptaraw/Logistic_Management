//
//  Helper.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

enum  StoryBoard: String {
    case Main, Order
}

enum OrderTabs: String {
    case All, MyOrders, Today, Queued, InTransit, Delivered, Cancelled
    
    func getTitle(count: Int) -> String {
        switch self {
        case .All:
            return "All Orders (\(count))"
        case .MyOrders:
            return "My Orders (\(count))"
        case .Today:
            return "Today (\(count))"
        case .Queued:
            return "All Queued (\(count))"
        case .InTransit:
            return "In Transit (\(count))"
        case .Delivered:
            return "Delivered (\(count))"
        case .Cancelled:
            return "Cancelled (\(count))"
        }
    }
}

extension OrderTabs:  CaseIterable {
    
}

//enum OrderTabs: CaseIterable {
//    case All(Int), MyOrders(Int), Today(Int), Queued(Int), InTransit(Int), Delivered(Int), Cancelled(Int)
//    var name: String {
//        switch self {
//        case .All(let count):
//            return "All Orders (\(count))"
//        case .MyOrders(let count):
//            return "My Orders (\(count))"
//        case .Today(let count):
//            return "Today (\(count))"
//        case .Queued(let count):
//            return "All Queued (\(count))"
//        case .InTransit(let count):
//            return "In Transit (\(count))"
//        case .Delivered(let count):
//            return "Delivered (\(count))"
//        case .Cancelled(let count):
//            return "Cancelled (\(count))"
//        }
//    }
//}

struct Helper {
    
    static func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    static func getViewControllerFromStoryboard(toStoryBoard storyBoardName: StoryBoard, initialViewControllerIdentifier identifier: String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyBoardName.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
}

