//
//  Date.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import Foundation

extension Date {
    /// Returns all the dates for the current week, starting from the first day of the week.
    func getCurrentWeekDays() -> [Date] {
        let calendar = Calendar.current        
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.start else {
            return []
        }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek)?.stripTime() }
    }
    
    func getCurrentDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Format to get the day as a string
        return formatter.string(from: self)
    }
    
    func stripTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    func getDateIndex() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let day = formatter.string(from: self.stripTime())
        return Int(day) ?? 0
    }
    
    var getDayWeek: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return (weekday + 5) % 7
    }
    
    /// Returns the day of the month as an integer (e.g., 1, 15, 31).
    var getDateDay: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    func getDayNumber(index: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dates = getCurrentWeekDays()
        let day = formatter.string(from: dates[index])
        return Int(day) ?? 0
    }
    
    func getDayNumberFromDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let day = formatter.string(from: self)
        return Int(day) ?? 0
    }
    
    func getDateByWeekIndex(index: Int) -> Date {
        return getCurrentWeekDays()[index]
    }
    
    func getIndexWeekByDate() -> Int? {
        return getCurrentWeekDays().firstIndex(of: self)
    }
}
