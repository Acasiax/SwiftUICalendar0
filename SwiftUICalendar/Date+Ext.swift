//
//  Date+Ext.swift
//  Calendar0.1
//
//  Created by 이윤지 on 2023/04/12.
//

import Foundation

extension Date {


    var startOfMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }



    var endOfMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        if let interval = calendar.dateInterval(of: .month, for: self),
            let lastDay = calendar.date(byAdding: .day, value: -1, to: interval.end) {
            return lastDay
        }
        return self
    }
    
    var endOfDay: Date {
        let calendar = Calendar(identifier: .gregorian)
        if let range = calendar.range(of: .day, in: .month, for: self) {
            let day = range.upperBound - 1
            var components = calendar.dateComponents([.year, .month, .day], from: self)
            components.day = day
            components.hour = 23
            components.minute = 59
            components.second = 59
            return calendar.date(from: components)!
        }
        return self
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var startOfNextMonth: Date {
        let dayInNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self)!
        return dayInNextMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        let calendar = Calendar(identifier: .gregorian)
        let endDateAdjustment = calendar.date(byAdding: DateComponents(day: -1), to: self.endOfMonth)!
        return calendar.component(.day, from: endDateAdjustment)
    }
    
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var monthFullName: String {
        self.formatted(.dateTime.month(.wide))
    }
    

    var startOfCalendarWithPrefixDays: Date {
         let calendar = Calendar(identifier: .gregorian)
         let startOfMonthWeekday = calendar.component(.weekday, from: self.startOfMonth)
         let numberOfPrefixDays = startOfMonthWeekday - 1
         let startDate = calendar.date(byAdding: .day, value: -startOfMonthWeekday, to: startOfMonth)!
         return startDate
     }


}
