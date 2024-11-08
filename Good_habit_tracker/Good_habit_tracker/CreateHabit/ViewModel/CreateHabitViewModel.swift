//
//  CreateHabitViewModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation

class CreateHabitViewModel {
    static let shared = CreateHabitViewModel()
    @Published var habits: [HabitModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchHabits { [weak self] habits, _ in
            guard let self = self else { return }
            self.habits = habits
        }
    }
    
    func saveHabit(habitsModel: [HabitModel], completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveHabit(habitModels: habitsModel, completion: completion)
    }
    
    func removeHabits(habits: [HabitModel]) {
        CoreDataManager.shared.removeHabits(habitModels: habits)
    }
    
    func clear() {
        
    }
}
