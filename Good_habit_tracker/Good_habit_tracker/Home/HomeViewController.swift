//
//  HomeViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var dayButtons: [DayButton]!
    @IBOutlet weak var bottomView: UIView!
    private let calendarButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        calendarButton.setImage(.calendar, for: .normal)
        calendarButton.addTarget(self, action: #selector(clickedCalendar), for: .touchUpInside)
        self.setNavigationTitle(title: "Today")
        self.setNaviagtionCalendarButton(button: calendarButton)
        self.setNaviagtionArchiveButton(image: .archive)
        titleLabels.forEach({ $0.font = .montserratRegular(size: 16) })
        dayButtons.forEach({ $0.titleLabel?.font = .montserratRegular(size: 20) })
        let currentDay = Date().getCurrentDayString()
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let weekDays = Date().getCurrentWeekDays()
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(formatter.string(from: weekDays[index]), for: .normal)
            if formatter.string(from: weekDays[index]) == currentDay {
                button.isSelected = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        bottomView.roundCorners([.topLeft, .topRight], radius: 30)

    }
    
    @objc func chooseCalendar() {
        
    }
    
    @IBAction func chooseDay(_ sender: DayButton) {
        self.dayButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
    }
    
    @IBAction func clickedAddHabit(_ sender: UIButton) {
    }
    @IBAction func clickedCalendar(_ sender: UIButton) {
    }
    @IBAction func clickedSettings(_ sender: UIButton) {
    }
}
