//
//  HabitModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation

struct HabitModel {
    var id: UUID?
    var name: String?
    var executionDays: [Date] = []
    var startDate: Date = Date().stripTime()
    var periodWeekly: [Int]? = [0,1,2,3,4,5,6]
    var periodMonthly: [Int]?
    var periodDates: [Date]?
}
