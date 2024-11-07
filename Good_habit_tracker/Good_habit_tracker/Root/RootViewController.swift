//
//  ViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .alternatesRegular(size: 33)
        descriptionLabel.font = .alternatesRegular(size: 22)
        startButton.titleLabel?.font = .alternatesMedium(size: 26)
    }
    
    @IBAction func clickedStart(_ sender: UIButton) {
    }
    
}

