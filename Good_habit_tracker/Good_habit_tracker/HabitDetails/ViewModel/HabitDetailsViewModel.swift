//
//  HabitDetailsViewModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 09.11.24.
//

import Foundation

class HabitDetailsViewModel {
    static let shared = HabitDetailsViewModel()
    @Published var habitModel: HabitModel?
    private init() {}
    
    func clear() {
        habitModel = nil
    }
    
    func pauseHabit(completion: @escaping (Error?) -> Void) {
        guard let id = habitModel?.id else { return }
        CoreDataManager.shared.pauseHabit(id: id, completion: completion)
    }
    
    func finishHabit(completion: @escaping (Error?) -> Void) {
        guard let id = habitModel?.id else { return }
        CoreDataManager.shared.stopHabit(id: id, completion: completion)
    }
    
    func getUnexecutedDays() -> Int {
        guard let habit = habitModel else { return 0 }
        let calendar = Calendar.current
        let currentDate = Date().stripTime()
        var unexecutedDays = 0
        guard habit.startDate <= currentDate else { return 0 }
        
        var date = habit.startDate
        while date <= currentDate {
            let weekdayIndex = date.getDayWeek
            let isExecutionDate: Bool = {
                if let weeklyPeriods = habit.periodWeekly, weeklyPeriods.contains(weekdayIndex) {
                    return true
                }
                if let monthlyPeriods = habit.periodMonthly, monthlyPeriods.contains(calendar.component(.day, from: date)) {
                    return true
                }
                if let specificDates = habit.periodDates, specificDates.contains(date.stripTime()) {
                    return true
                }
                return false
            }()
            
            if isExecutionDate, !habit.executionDays.contains(date.stripTime()) {
                unexecutedDays += 1
            }
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return unexecutedDays
    }
}
