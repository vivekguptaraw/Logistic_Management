//
//  Date+Addditions.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 25/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

extension Date {
    static var midnight: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dateAtMidnight = calendar.startOfDay(for: Date())
        return dateAtMidnight
    }
}
