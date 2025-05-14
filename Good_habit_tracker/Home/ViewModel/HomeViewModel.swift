//
//  HomeViewMode.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    private var allHabits: [HabitModel] = []
    @Published var habits: [HabitModel] = []
    @Published var date = Date().stripTime()
    private var selectedWeekDay: Int?
    private var selectedDay: Date?
    
    private init() {}
    func fetchData() {
        CoreDataManager.shared.fetchMyHabits { [weak self] habits, _ in
            guard let self = self else { return }
            self.allHabits = habits
            if let selectedWeekDay = selectedWeekDay {
                chooseWeekDay(day: selectedWeekDay)
            } else if let selectedDay = selectedDay {
                self.chooseDay(day: selectedDay)
            } else {
                self.habits = allHabits
            }
        }
    }
    
    func performHabit(id: UUID, isPerform: Bool, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.performHabit(id: id, by: date, isPerform: isPerform, completion: completion)
    }
    
    func chooseDay(day: Date) {
        selectedDay = day
        selectedWeekDay = nil
        habits = allHabits.filter { habit in
            if let weeklyPeriods = habit.periodWeekly, weeklyPeriods.contains(day.getDayWeek) {
                return true
            }
            if let monthlyPeriods = habit.periodMonthly {
                return monthlyPeriods.contains(day.getDayNumberFromDate())
            }
            if let specificDates = habit.periodDates {
                return specificDates.contains(where: { $0 == day })
            }
            return false
        }
    }
    
    func chooseWeekDay(day: Int) {
        selectedWeekDay = day
        selectedDay = nil
        habits = allHabits.filter { habit in
            if let weeklyPeriods = habit.periodWeekly, weeklyPeriods.contains(day) {
                return true
            }
            if let monthlyPeriods = habit.periodMonthly {
                let date = Date().getDayNumber(index: day)
                return monthlyPeriods.contains(date)
            }
            if let specificDates = habit.periodDates {
                return specificDates.contains(where: { $0 == Date().getDateByWeekIndex(index: day) })
            }
            return false
        }
    }

}
