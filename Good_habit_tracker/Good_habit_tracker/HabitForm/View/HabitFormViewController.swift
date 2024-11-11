//
//  HabitFormViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit

class HabitFormViewController: UIViewController {

    @IBOutlet weak var habitTextField: BaseTextField!
    @IBOutlet weak var nextButton: BaseButton!
    @IBOutlet var dayButtons: [DayButton]!
    private let viewModel = HabitFormViewModel.shared
    private let weekDays = Date().getCurrentWeekDays()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Today")
        setNaviagtionBackButton(image: .backButton)
        habitTextField.delegate = self
        nextButton.isEnabled = viewModel.habit.name.checkValidation()
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        for (index, button) in dayButtons.enumerated() {
            button.setTitle(formatter.string(from: weekDays[index]), for: .normal)
            if weekDays[index] == Date().stripTime() {
                button.isSelected = true
            }
        }
    }

    @IBAction func clickedNext(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension HabitFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.habit.name = textField.text
        nextButton.isEnabled = viewModel.habit.name.checkValidation()
    }
}
