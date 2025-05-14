//
//  ArchiveViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 11.11.24.
//

import UIKit
import Combine

class ArchiveViewController: UIViewController {
    @IBOutlet var dayButtons: [DayButton]!
    @IBOutlet weak var pauseButton: TabButton!
    @IBOutlet weak var finishButton: TabButton!
    @IBOutlet weak var habitsTableView: UITableView!
    private let weekDays = Date().getCurrentWeekDays()
    private let viewModel = ArchiveViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Archive")
        setNaviagtionBackButton(image: .closeButton)
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(formatter.string(from: weekDays[index]), for: .normal)
            if weekDays[index] == Date().stripTime() {
                button.isSelected = true
            }
        }
        pauseButton.isSelected = true
        finishButton.isSelected = false
        habitsTableView.register(UINib(nibName: "ArchiveTableViewCell", bundle: nil), forCellReuseIdentifier: "ArchiveTableViewCell")
        habitsTableView.delegate = self
        habitsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                guard let self = self else { return }
                self.habitsTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @IBAction func choosePauseTab(_ sender: TabButton) {
        sender.isSelected = true
        finishButton.isSelected = false
        viewModel.chooseTab(tab: .pause)
    }
    
    @IBAction func chooseFinishTab(_ sender: TabButton) {
        sender.isSelected = true
        pauseButton.isSelected = false
        viewModel.chooseTab(tab: .finish)
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.habits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as! ArchiveTableViewCell
        cell.configure(habit: viewModel.habits[indexPath.section], tab: viewModel.selectedTab)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        HabitDetailsViewModel.shared.habitModel = viewModel.habits[indexPath.section]
//        self.pushViewController(HabitDetailsViewController.self)
//    }
}

extension ArchiveViewController: ArchiveTableViewDelegate {
    func start(habit: HabitModel) {
        viewModel.resumeHabit(id: habit.id ?? UUID()) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                NotificationManager.shared.scheduleNotifications(habitModel: habit)
                self.viewModel.fetchData()
            }
        }
    }
}
