//
//  Date+Extension.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 18/03/21.
//

import Foundation

extension Date {
    
    static func dateInStringForm(time:Date) ->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let formattedTimeZoneStr = formatter.string(from: time)
        print(formattedTimeZoneStr)
        return formattedTimeZoneStr
    }
    
    static func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
}
