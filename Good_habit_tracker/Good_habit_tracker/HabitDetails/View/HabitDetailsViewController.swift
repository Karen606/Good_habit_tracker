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
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.present(alertVC, animated: false)
    }
    
    @IBAction func clickedReminder(_ sender: UIButton) {
    }
    
    @IBAction func clickedCalendar(_ sender: UIButton) {
        HabitPeriodViewModel.shared.habit = viewModel.habitModel
        self.pushViewController(HabitPeriodViewController.self)
    }
    
    deinit {
        viewModel.clear()
    }
}
