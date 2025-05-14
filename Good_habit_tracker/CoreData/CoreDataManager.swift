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
                newHabitModel.periodWeekly = habitModel.periodWeekly
                newHabitModel.periodMonthly = habitModel.periodMonthly
                newHabitModel.periodDates = habitModel.periodDates
                newHabitModel.reminderTime = habitModel.reminderTime
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
                    let habitModel = HabitModel(id: result.id, name: result.name, periodWeekly: result.periodWeekly, periodMonthly: result.periodMonthly, periodDates: result.periodDates, reminderTime: result.reminderTime)
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
            } catch {
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
                newHabitModel.periodWeekly = habitModel.periodWeekly
                newHabitModel.periodMonthly = habitModel.periodMonthly
                newHabitModel.periodDates = habitModel.periodDates
                newHabitModel.reminderTime = habitModel.reminderTime
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
                    let habitModel = HabitModel(id: result.id, name: result.name, executionDays: result.executionDays ?? [], periodWeekly: result.periodWeekly, periodMonthly: result.periodMonthly, periodDates: result.periodDates, reminderTime: result.reminderTime)
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
                        if !executionDays.contains(date) {
                            executionDays.append(date)
                        }
                    } else {
                        if let index = executionDays.firstIndex(of: date) {
                            executionDays.remove(at: index)
                        }
                    }
                    
                    habit.executionDays = executionDays
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
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
    
    func updateHabitPeriod(id: UUID, periodWeekly: [Int]?, periodMonthly: [Int]?, periodDates: [Date]?, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habit = results.first {
                    habit.periodWeekly = periodWeekly
                    habit.periodMonthly = periodMonthly
                    habit.periodDates = periodDates
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "com.example.MyApp", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func setHabitReminder(id: UUID, reminderTime: Date) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habit = results.first {
                    habit.reminderTime = reminderTime
                    try backgroundContext.save()
                }
            } catch {
            }
        }
    }

    func pauseHabit(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habitToPause = results.first {
                    let pausedHabit = PausedHabit(context: backgroundContext)
                    pausedHabit.id = habitToPause.id
                    pausedHabit.name = habitToPause.name
                    pausedHabit.executionDays = habitToPause.executionDays
                    pausedHabit.periodWeekly = habitToPause.periodWeekly
                    pausedHabit.periodMonthly = habitToPause.periodMonthly
                    pausedHabit.periodDates = habitToPause.periodDates
                    pausedHabit.reminderTime = habitToPause.reminderTime
                    backgroundContext.delete(habitToPause)
                    
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "com.example.MyApp", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func stopHabit(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyHabit> = MyHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habitToStop = results.first {
                    let stoppedHabit = StoppedHabit(context: backgroundContext)
                    stoppedHabit.id = habitToStop.id
                    stoppedHabit.name = habitToStop.name
                    stoppedHabit.executionDays = habitToStop.executionDays
                    stoppedHabit.periodWeekly = habitToStop.periodWeekly
                    stoppedHabit.periodMonthly = habitToStop.periodMonthly
                    stoppedHabit.periodDates = habitToStop.periodDates
                    stoppedHabit.reminderTime = habitToStop.reminderTime
                    backgroundContext.delete(habitToStop)
                    
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "com.example.MyApp", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPausedHabits(completion: @escaping ([HabitModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<PausedHabit> = PausedHabit.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var habitModels: [HabitModel] = []
                for result in results {
                    let habitModel = HabitModel(id: result.id, name: result.name, executionDays: result.executionDays ?? [], periodWeekly: result.periodWeekly, periodMonthly: result.periodMonthly, periodDates: result.periodDates, reminderTime: result.reminderTime)
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
    
    func fetchStoppedHabits(completion: @escaping ([HabitModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<StoppedHabit> = StoppedHabit.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var habitModels: [HabitModel] = []
                for result in results {
                    let habitModel = HabitModel(id: result.id, name: result.name, executionDays: result.executionDays ?? [], periodWeekly: result.periodWeekly, periodMonthly: result.periodMonthly, periodDates: result.periodDates, reminderTime: result.reminderTime)
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

    func startHabit(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<PausedHabit> = PausedHabit.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let habitToStart = results.first {
                    let myHabit = MyHabit(context: backgroundContext)
                    myHabit.id = habitToStart.id
                    myHabit.name = habitToStart.name
                    myHabit.executionDays = habitToStart.executionDays
                    myHabit.periodWeekly = habitToStart.periodWeekly
                    myHabit.periodMonthly = habitToStart.periodMonthly
                    myHabit.periodDates = habitToStart.periodDates
                    myHabit.reminderTime = habitToStart.reminderTime
                    backgroundContext.delete(habitToStart)
                    
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "com.example.MyApp", code: 404, userInfo: [NSLocalizedDescriptionKey: "Habit not found in PausedHabit"]))
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
