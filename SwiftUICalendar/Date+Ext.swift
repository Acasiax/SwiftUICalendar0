//
//  Date+Ext.swift
//  Calendar0.1
//
//  Created by 이윤지 on 2023/04/12.
//

import Foundation

extension Date {


//    var startOfMonth: Date {
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
//        let components = calendar.dateComponents([.year, .month], from: self)
//        return calendar.date(from: components)!
//    }
    func monthYearString() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MMMM"
            return dateFormatter.string(from: self)
        }

    
    var startOfMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)!
        let startOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)
        let numberOfPrefixDays = startOfMonthWeekday - 1
        let startDate = calendar.date(byAdding: .day, value: -numberOfPrefixDays, to: startOfMonth)!
        return startDate
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

    

    
//    var startOfNextMonth: Date? {
//        guard let dayInNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self) else {
//            return nil
//        }
//        return dayInNextMonth.startOfMonth
//    }

    
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

 
       
    func minusMonth(_ months: Int) -> Date {
           var components = DateComponents()
           components.month = -months
           return Calendar.current.date(byAdding: components, to: self)!
       }
       
       func plusMonth(_ months: Int) -> Date {
           var components = DateComponents()
           components.month = months
           return Calendar.current.date(byAdding: components, to: self)!
       }
       
       
       func daysInMonth(_ date: Date) -> Int
       {
           let calendar = Calendar(identifier: .gregorian)
           let range = calendar.range(of: .day, in: .month, for: date)!
           return range.count
       }
       
       func dayOfMonth(_ date: Date) -> Int
       {
           let calendar = Calendar(identifier: .gregorian)
           let components = calendar.dateComponents([.day], from: date)
           return components.day!
       }
       
       func firstOfMonth(_ date: Date) -> Date
       {
           let calendar = Calendar(identifier: .gregorian)
           let components = calendar.dateComponents([.year, .month], from: date)
           return calendar.date(from: components)!
       }
       
       func weekDay(_ date: Date) -> Int
       {
           let calendar = Calendar(identifier: .gregorian)
           let components = calendar.dateComponents([.weekday], from: date)
           return components.weekday! - 1
       }
    
   
}
