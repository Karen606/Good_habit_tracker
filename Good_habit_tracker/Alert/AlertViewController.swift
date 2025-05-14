//
//  AlertViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 11.11.24.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    var isPause = false
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background.withAlphaComponent(0.4)
        contentView.addShadow()
        if isPause {
            titleLabel.text = "If for some reason you are temporarily unable to perform a habit, put it on pause"
            confirmButton.setTitle("Pause", for: .normal)
        } else {
            titleLabel.text = "End the habit if you have developed it and are doing it without the help of the app. After completion, it will go to the archive"
            confirmButton.setTitle("Finish", for: .normal)
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func chooseConfirm(_ sender: UIButton) {
        completion?()
        self.dismiss(animated: false)
    }
}
