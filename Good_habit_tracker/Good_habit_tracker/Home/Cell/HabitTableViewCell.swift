//
//  HabitTableViewCell.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit

protocol HabitTableViewDelegate: AnyObject {
    func performHabit(id: UUID, isPerform: Bool)
}

class HabitTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    private var id: UUID?
    weak var delegate: HabitTableViewDelegate?
    
    var habitIsPerform: Bool = false {
        didSet {
            nameLabel.textColor = habitIsPerform ? .whiteText : .black
            radioButton.isSelected = habitIsPerform
            self.bgView.backgroundColor = habitIsPerform ? .basePurple : .baseGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        id = nil
    }
    
    func configure(habit: HabitModel) {
        self.id = habit.id
        nameLabel.text = habit.name
        habitIsPerform = habit.executionDays.contains(where: { $0 == HomeViewModel.shared.date })
    }
    
    @IBAction func clickedRadio(_ sender: UIButton) {
        guard let id = id else { return }
        delegate?.performHabit(id: id, isPerform: !sender.isSelected)
    }
}
