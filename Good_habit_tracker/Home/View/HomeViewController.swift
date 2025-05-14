//
//  HomeViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var dayButtons: [DayButton]!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var archiveButton: UIButton!
    private let weekDays = Date().getCurrentWeekDays()
    private let datePicker = UIDatePicker()
    private let textField = UITextField()
    private let calendarButton = UIButton(type: .custom)
    private let viewModel = HomeViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
        archiveButton.isHidden = !UserDefaults.standard.bool(forKey: "isArchiveEnabled")
    }
    
    func setupUI() {
        calendarButton.setImage(.calendar, for: .normal)
        calendarButton.addTarget(self, action: #selector(chooseCalendar), for: .touchUpInside)
        self.setNavigationTitle(title: "Today")
        self.setNaviagtionCalendarButton(button: calendarButton)
        titleLabels.forEach({ $0.font = .montserratRegular(size: 16) })
        dayButtons.forEach({ $0.titleLabel?.font = .montserratRegular(size: 20) })
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(formatter.string(from: weekDays[index]), for: .normal)
            if weekDays[index] == viewModel.date {
                button.isSelected = true
                viewModel.chooseWeekDay(day: index)
            }
        }
        textField.isHidden = true
        view.addSubview(textField)
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textField.inputView = datePicker
        habitsTableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: "HabitTableViewCell")
        habitsTableView.delegate = self
        habitsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] partyModel in
                guard let self = self else { return }
                self.habitsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        bottomView.roundCorners([.topLeft, .topRight], radius: 30)

    }
    
    @objc func dateChanged() {
        viewModel.date = datePicker.date.stripTime()
        viewModel.fetchData()
        textField.resignFirstResponder()
        for (index, button) in dayButtons.enumerated() {
            button.isSelected = weekDays[index] == viewModel.date
        }
        viewModel.chooseDay(day: datePicker.date)
    }
    
    @objc func chooseCalendar() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }
    
    @IBAction func chooseDay(_ sender: DayButton) {
        self.dayButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        viewModel.date = weekDays[sender.tag]
        viewModel.chooseWeekDay(day: sender.tag)
    }
    
    @IBAction func clickedAddHabit(_ sender: UIButton) {
        self.pushViewController(CreateHabitViewController.self)
    }
    
    @IBAction func clickedArchive(_ sender: UIButton) {
        self.pushViewController(ArchiveViewController.self)
    }
    
    @IBAction func clickedSettings(_ sender: UIButton) {
        self.pushViewController(SettingsViewController.self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.habits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitTableViewCell", for: indexPath) as! HabitTableViewCell
        cell.configure(habit: viewModel.habits[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HabitDetailsViewModel.shared.habitModel = viewModel.habits[indexPath.section]
        self.pushViewController(HabitDetailsViewController.self)
    }
}

extension HomeViewController: HabitTableViewDelegate {
    func performHabit(id: UUID, isPerform: Bool) {
        viewModel.performHabit(id: id, isPerform: isPerform) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                viewModel.fetchData()
            }
        }
    }
}
