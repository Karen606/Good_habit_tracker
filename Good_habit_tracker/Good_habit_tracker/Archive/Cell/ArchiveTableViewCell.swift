//
//  ArchiveTableViewCell.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 12.11.24.
//

import UIKit

protocol ArchiveTableViewDelegate: AnyObject {
    func start(id: UUID)
}

class ArchiveTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    private var id: UUID?
    weak var delegate: ArchiveTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(habit: HabitModel, tab: Section) {
        id = habit.id
        nameLabel.text = habit.name
        startButton.isHidden = tab == .finish
    }
    
    @IBAction func clickedStart(_ sender: UIButton) {
        guard let id = id else { return }
        delegate?.start(id: id)
    }
    
}
