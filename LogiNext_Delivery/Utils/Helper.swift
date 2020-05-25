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
    
    static func valueAtIndex(index: Int) -> OrderTabs {
        switch index {
        case 0:
            return .All
        case 1:
            return .MyOrders
        case 2:
            return .Today
        case 3:
            return .Queued
        case 4:
            return .InTransit
        case 5:
            return .Delivered
        case 6:
            return .Cancelled
        default:
            return .All
        }
    }
    
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

extension OrderTabs:  CaseIterable {}

struct Helper {
    
    static func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    static func getString(from date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let dt = date, let str = dateFormatter.string(from: dt) as? String {
            return str
        }
        return ""
    }
    
    static func getViewControllerFromStoryboard(toStoryBoard storyBoardName: StoryBoard, initialViewControllerIdentifier identifier: String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyBoardName.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
}

