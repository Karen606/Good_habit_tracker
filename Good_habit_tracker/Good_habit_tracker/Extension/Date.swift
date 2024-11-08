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
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func getCurrentDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Format to get the day as a string
        return formatter.string(from: self)
    }
}
