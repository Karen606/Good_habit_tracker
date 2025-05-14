//
//  DayButton.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

class DayButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .basePurple
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .baseYelow
                self.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
