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
}
