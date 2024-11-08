//
//  HabitFormViewModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation

class HabitFormViewModel {
    static let shared = HabitFormViewModel()
    var habit = HabitModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveHabit(habitModels: [habit], completion: completion)
    }
    
    func clear() {
        habit = HabitModel(id: UUID())
    }
}
