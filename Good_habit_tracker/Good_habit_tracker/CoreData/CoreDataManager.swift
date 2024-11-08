//
//  CoreDataManager.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Good_habit_tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func addDefaultHabits(habitModels: [HabitModel], completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            for habitModel in habitModels {
                let newHabitModel = Habit(context: backgroundContext)
                newHabitModel.id = UUID()
                newHabitModel.name = habitModel.name
            }
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchHabits(completion: @escaping ([HabitModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var habitModels: [HabitModel] = []
                for result in results {
                    let habitModel = HabitModel(id: result.id, name: result.name)
                    habitModels.append(habitModel)
                }
                completion(habitModels, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}
