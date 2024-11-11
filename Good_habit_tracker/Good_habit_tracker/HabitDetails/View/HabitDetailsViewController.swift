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
                self.executionsLabel.text = "\(habit.executionDays.count)"
            }
            .store(in: &cancellables)
    }

    @IBAction func clickedPause(_ sender: UIButton) {
    }
    @IBAction func clickedFinish(_ sender: UIButton) {
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
