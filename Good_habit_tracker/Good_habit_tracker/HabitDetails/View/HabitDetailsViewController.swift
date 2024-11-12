//
//  HabitDetailsViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit
import Combine

class HabitDetailsViewController: UIViewController {

    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var gapsCountLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var executionsLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet var dayButtons: [DayButton]!
    private let datePicker = UIDatePicker()
    private let textField = UITextField()

    private let weekDays = Date().getCurrentWeekDays()
    private let viewModel = HabitDetailsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionBackButton(image: .closeButton)
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(formatter.string(from: weekDays[index]), for: .normal)
            if weekDays[index] == Date().stripTime() {
                button.isSelected = true
            }
        }
        pauseButton.addShadow()
        finishButton.addShadow()
        textField.isHidden = true
        view.addSubview(textField)
        textField.inputView = datePicker
        datePicker.datePickerMode = .countDownTimer
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateChanged))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Adds spacing
        toolbar.setItems([space, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    func subscribe() {
        viewModel.$habitModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habitModel in
                guard let self = self, let habit = habitModel else { return }
                self.setNavigationTitle(title: habit.name ?? "")
                self.habitLabel.text = habit.name
                let executions = habit.executionDays.count
                let gaps = viewModel.getUnexecutedDays()
                self.executionsLabel.text = "\(executions)"
                self.gapsCountLabel.text = "\(gaps)"
                var percent = executions * 100 / (executions + gaps)
                if percent > 100 {
                    percent = 100
                }
                self.percentLabel.text = "\(percent)%"
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        textField.resignFirstResponder()
    }
    
    @objc func dateChanged() {
        textField.resignFirstResponder()
        viewModel.habitModel?.reminderTime = datePicker.date
        viewModel.setReminderDate(time: datePicker.date)
    }
    
    @objc func chooseCalendar() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }

    @IBAction func clickedPause(_ sender: UIButton) {
        let alertVC = AlertViewController(nibName: "AlertViewController", bundle: nil)
        alertVC.isPause = true
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.completion = { [weak self] in
            guard let self = self else { return }
            viewModel.pauseHabit { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    NotificationManager.shared.cancelNotifications(for: viewModel.habitModel?.id?.uuidString ?? UUID().uuidString)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.present(alertVC, animated: false)
    }
    
    @IBAction func clickedFinish(_ sender: UIButton) {
        let alertVC = AlertViewController(nibName: "AlertViewController", bundle: nil)
        alertVC.isPause = false
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.finishHabit { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    NotificationManager.shared.cancelNotifications(for: viewModel.habitModel?.id?.uuidString ?? UUID().uuidString)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.present(alertVC, animated: false)
    }
    
    @IBAction func clickedReminder(_ sender: UIButton) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }

    }
    
    @IBAction func clickedCalendar(_ sender: UIButton) {
        HabitPeriodViewModel.shared.habit = viewModel.habitModel
        self.pushViewController(HabitPeriodViewController.self)
    }
    
    deinit {
        viewModel.clear()
    }
}
