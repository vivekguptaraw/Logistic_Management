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
    case All, MyAllOrders, MyToday, MyQueued, MyInTransit, MyDelivered, MyCancelled,
    AllToday, AllQueued, AllInTransit, AllDelivered, AllCancelled
    
    var isForCurrentUser: Bool {
        switch self {
        case .MyAllOrders, .MyToday, .MyQueued, .MyInTransit, .MyDelivered, .MyCancelled:
            return true
        case .All, .AllToday, .AllQueued, .AllInTransit, .AllDelivered, .AllCancelled :
            return false
        }
    }
    
    static func valueAtIndex(index: Int) -> OrderTabs {
        switch index {
        case 0:
            return .All
        case 1:
            return .MyAllOrders
        case 2:
            return .MyToday
        case 3:
            return .MyQueued
        case 4:
            return .MyInTransit
        case 5:
            return .MyDelivered
        case 6:
            return .MyCancelled
        case 7:
            return .AllToday
        case 8:
            return .AllQueued
        case 9:
            return .AllInTransit
        case 10:
            return .AllDelivered
        case 11:
            return .AllCancelled
        default:
            return .All
        }
    }
    
    func getTitle(count: Int?) -> String {
        var str = ""
        if let cnt = count {
            str = " (\(cnt))"
        }
        switch self {
        case .All:
            return "All Orders\(str)"
        case .MyAllOrders:
            return "My All Orders\(str)"
        case .MyToday:
            return "My Today's Orders\(str)"
        case .MyQueued:
            return "My Queued\(str)"
        case .MyInTransit:
            return "My Transit\(str)"
        case .MyDelivered:
            return "My Delivered\(str)"
        case .MyCancelled:
            return "My Cancelled\(str)"
        case .AllToday:
            return "All Today's Orders\(str)"
        case .AllQueued:
            return "All Queued\(str)"
        case .AllInTransit:
            return "All In-Transit\(str)"
        case .AllDelivered:
            return "All Delivered\(str)"
        case .AllCancelled:
            return "All Cancelled\(str)"
        }
    }
}

extension OrderTabs:  CaseIterable {}

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

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
        dateFormatter.dateFormat = "E, dd-MM-yyyy HH:mm a"
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

