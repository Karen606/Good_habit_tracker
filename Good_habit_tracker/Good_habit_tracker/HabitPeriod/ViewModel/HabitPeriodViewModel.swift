//
//  HabitPeriodViewModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 10.11.24.
//

import Foundation

class HabitPeriodViewModel {
    static let shared = HabitPeriodViewModel()
    @Published var habit: HabitModel?
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        if let id = habit?.id {
            CoreDataManager.shared.updateHabitPeriod(id: id, periodWeekly: habit?.periodWeekly, periodMonthly: habit?.periodMonthly, periodDates: habit?.periodDates, completion: completion)
        }
    }
    
    func setWeekDays(days: [Int]) {
        habit?.periodWeekly = days
        habit?.periodMonthly = nil
        habit?.periodDates = nil
    }
    
    func setMonthly(days: [Int]) {
        habit?.periodMonthly = days
        habit?.periodDates = nil
        habit?.periodWeekly = nil
    }
    
    func setPeriod(period: [Date]) {
        habit?.periodDates = period
        habit?.periodMonthly = nil
        habit?.periodWeekly = nil
    }
}
