//
//  TabButton.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 11.11.24.
//

import UIKit

class TabButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .basePurple : .baseYelow
            if isSelected {
                self.removeShadow()
            } else {
                self.addShadow()
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

