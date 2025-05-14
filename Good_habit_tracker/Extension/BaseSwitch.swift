//
//  BaseSwitch.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 12.11.24.
//


import UIKit

class BaseSwitch: UISwitch {
    override var isOn: Bool {
        didSet {
            self.thumbTintColor = isOn ? .basePurple : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        }
    }
}
