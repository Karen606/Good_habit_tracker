//
//  HomeViewMode.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    @Published var habits: [HabitModel] = []
    @Published var date = Date().stripTime()
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMyHabits { [weak self] habits, _ in
            guard let self = self else { return }
            self.habits = habits
        }
    }
    
    func performHabit(id: UUID, isPerform: Bool, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.performHabit(id: id, by: date, isPerform: isPerform, completion: completion)
    }
}
