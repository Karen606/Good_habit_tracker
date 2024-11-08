//
//  HabitCollectionViewCell.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 1 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .baseGray
        self.layer.borderColor = UIColor.text.cgColor
        self.layer.cornerRadius = 6
    }
    
    func configure(habit: HabitModel) {
        nameLabel.text = habit.name
    }

}
