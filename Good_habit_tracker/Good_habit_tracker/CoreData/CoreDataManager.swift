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
    
    func removeHabits(habitModels: [HabitModel]) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()

            do {
                // Fetch all habits
                let results = try backgroundContext.fetch(fetchRequest)

                // Filter the habits that match the given names in habitModels
                for habitModel in habitModels {
                    if let habitToDelete = results.first(where: { $0.name == habitModel.name }) {
                        backgroundContext.delete(habitToDelete)
                    }
                }

                // Save the context to persist the changes
                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
            }
        }
    }

    
    func saveHabit(habitModels: [HabitModel], completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            for habitModel in habitModels {
                let newHabitModel = MyHabit(context: backgroundContext)
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
    
    func fetchMyHabits(completion: @escaping ([HabitModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var habitModels: [HabitModel] = []
                for result in results {
                    let habitModel = HabitModel(id: result.id, name: result.name, executionDays: result.executionDays ?? [])
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
    
    func performHabit(id: UUID, by date: Date, isPerform: Bool, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habit = results.first {
                    var executionDays = habit.executionDays ?? []
                    
                    if isPerform {
                        // Add the date if it's not already in the array
                        if !executionDays.contains(date) {
                            executionDays.append(date)
                        }
                    } else {
                        // Remove the date if it exists in the array
                        if let index = executionDays.firstIndex(of: date) {
                            executionDays.remove(at: index)
                        }
                    }
                    
                    habit.executionDays = executionDays
                    
                    // Save the changes
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    // Habit not found
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

}
