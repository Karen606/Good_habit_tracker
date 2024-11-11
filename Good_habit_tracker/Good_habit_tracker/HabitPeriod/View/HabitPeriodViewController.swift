//
//  HabitPeriodViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 10.11.24.
//

import UIKit
import FSCalendar
import Combine

class HabitPeriodViewController: UIViewController {

    @IBOutlet var weekButtons: [DayButton]!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var confirmButton: UIButton!
    private let viewModel = HabitPeriodViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionBackButton(image: .closeButton)
        setNavigationTitle(title: viewModel.habit?.name ?? "")
        
        calendarView.backgroundColor = .background
        calendarView.layer.cornerRadius = 8
        calendarView.addShadow()
        calendar.allowsMultipleSelection = true
        calendar.delegate = self
        tapGesture.delegate = self
    }
    
    func subscribe() {
        viewModel.$habit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habit in
                guard let self = self else { return }
                if let periodWeekly = habit?.periodWeekly {
                    for index in periodWeekly {
                        weekButtons[index].isSelected = true
                    }
                    for date in calendar.selectedDates {
                        calendar.deselect(date)
                    }
                } else {
                    weekButtons.forEach({ $0.isSelected = false })
                }
                if let periodMonthly = habit?.periodMonthly {
                    
                } else if let period = habit?.periodDates {
                    let dates = datesRange(from: period[0], to: period[1])
                    for date in dates {
                        self.calendar.select(date)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func getDatesInRange(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let calendar = Calendar.current

        while currentDate <= endDate {
            dates.append(currentDate)
            // Add one day to the current date
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return dates
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        calendarView.isHidden = true
    }
    
    @IBAction func chooseWeekDay(_ sender: DayButton) {
        sender.isSelected = !sender.isSelected
        let buttons = weekButtons.filter({ $0.isSelected })
        let days = buttons.map({ $0.tag })
        viewModel.setWeekDays(days: days)
    }
    
    @IBAction func chooseMonthly(_ sender: UIButton) {
        calendar.tag = 0
        calendarView.isHidden = false
    }
    
    @IBAction func choosePeriod(_ sender: UIButton) {
        calendar.tag = 1
        calendarView.isHidden = false
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        calendarView.isHidden = true
    }
    
    @IBAction func clickedConfirm(_ sender: UIButton) {
        calendarView.isHidden = true
        if calendar.tag == 1 {
            viewModel.setPeriod(period: calendar.selectedDates)
        } else {
            var days: [Int] = []
            for date in calendar.selectedDates {
                days.append(date.getDateIndex())
            }
            viewModel.setMonthly(days: days)
        }
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        let indexButtons: [Int] = weekButtons.enumerated().compactMap { index, button in
            button.isSelected ? index : nil
        }
        viewModel.habit?.periodWeekly = indexButtons
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension HabitPeriodViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard calendar.tag == 1 else { return }
        var dates = [Date]()
        if calendar.selectedDates.count == 2 {
            if calendar.selectedDates.first! > calendar.selectedDates.last! {
                dates = calendar.selectedDates.reversed()
            } else {
                dates = calendar.selectedDates
            }
            let range = datesRange(from: dates.first!, to: dates.last!)
            for d in range {
                calendar.select(d)
            }
        } else if calendar.selectedDates.count > 2 {
            for d in calendar.selectedDates {
                if d != date {
                    calendar.deselect(d)
                }
            }
        }
        confirmButton.isEnabled = calendar.selectedDates.count > 1
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard calendar.tag == 1 else { return }
        if !calendar.selectedDates.isEmpty {
            calendar.selectedDates.forEach({ calendar.deselect($0) })
            calendar.select(date)
        }
        confirmButton.isEnabled = calendar.selectedDates.count > 1
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard calendar.tag == 1 else { return true }
        if calendar.selectedDates.count == 1 && calendar.selectedDates[0] == date {
            confirmButton.isEnabled.toggle()
            return false
        }
        return true
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        return Date() >= date
//    }
    
}



extension HabitPeriodViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(self.view.hitTest(touch.location(in: self.view), with: nil)?.isDescendant(of: calendarView) == true)
    }
}
