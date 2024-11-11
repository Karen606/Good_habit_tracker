//
//  ArchiveViewModel.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 11.11.24.
//

import Foundation

class ArchiveViewModel {
    static let shared = ArchiveViewModel()
    var selectedTab: Section = .pause
    @Published var habits: [HabitModel] = []
    private var pausedHabits: [HabitModel] = []
    private var stoppedHabits: [HabitModel] = []
    
    private init() {}
    func fetchData() {
        CoreDataManager.shared.fetchPausedHabits { [weak self] habits, _ in
            guard let self = self else { return }
            self.pausedHabits = habits
            if selectedTab == .pause {
                self.habits = habits
            }
        }
        
        CoreDataManager.shared.fetchStoppedHabits { [weak self] habits, _ in
            guard let self = self else { return }
            self.stoppedHabits = habits
            if selectedTab == .finish {
                self.habits = habits
            }
        }
    }
    
    func resumeHabit(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.startHabit(id: id, completion: completion)
    }
    
    func chooseTab(tab: Section) {
        self.selectedTab = tab
        self.habits = (selectedTab == .pause) ? pausedHabits : stoppedHabits
    }
}

enum Section {
    case pause
    case finish
}
