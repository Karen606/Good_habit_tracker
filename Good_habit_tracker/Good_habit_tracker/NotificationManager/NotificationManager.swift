//
//  NotificationManager.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 12.11.24.
//


import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                    completion(false)
                }
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    completion(true)
                }
            @unknown default:
                completion(false)
            }
        }
    }
    
    // MARK: - Show Settings Alert
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Enable Notifications",
            message: "Please enable notifications in Settings to receive alerts.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
    }

    func scheduleNotification(for date: Date, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(date)")
            }
        }
    }
    
    func cancelNotifications(for habitID: String) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let identifiersToCancel = requests
                    .filter { $0.identifier.starts(with: habitID) }
                    .map { $0.identifier }
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToCancel)
            }
        }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func isNotificationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
    }
    
    func notificationDates(habitModel: HabitModel?) -> [Date] {
        guard let reminderTime = habitModel?.reminderTime, let habit = habitModel else { return [] }
        let calendar = Calendar.current
        let currentDate = Date().stripTime()
        let endDate = currentDate.addingTimeInterval(7 * 86400) // Schedule for 1 week ahead (customize as needed)
        var dates = [Date]()
        
        var date = habit.startDate
        while date <= endDate {
            let weekdayIndex = date.getDayWeek
            let isExecutionDate: Bool = {
                if let weekly = habit.periodWeekly, weekly.contains(weekdayIndex) {
                    return true
                }
                if let monthly = habit.periodMonthly, monthly.contains(calendar.component(.day, from: date)) {
                    return true
                }
                if let specificDates = habit.periodDates, specificDates.contains(date.stripTime()) {
                    return true
                }
                return false
            }()
            
            if isExecutionDate {
                if let reminderDate = calendar.date(bySettingHour: calendar.component(.hour, from: reminderTime),
                                                    minute: calendar.component(.minute, from: reminderTime),
                                                    second: 0, of: date) {
                    dates.append(reminderDate)
                }
            }
            
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
    }
    
    func scheduleNotifications(habitModel: HabitModel?) {
        guard let habit = habitModel else { return }
        let notificationDates = notificationDates(habitModel: habitModel)
        let identifier = habit.id?.uuidString ?? UUID().uuidString
        NotificationManager.shared.cancelNotifications(for: habit.id?.uuidString ?? UUID().uuidString)
        notificationDates.forEach { date in
            let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
            let identifier = "\(habit.id?.uuidString ?? UUID().uuidString)-\(dateString)"
            NotificationManager.shared.scheduleNotification(
                for: date,
                title: "Reminder for \(habit.name ?? "Habit")",
                body: "Don't forget to complete your habit!", identifier: identifier
            )
        }
    }
}
