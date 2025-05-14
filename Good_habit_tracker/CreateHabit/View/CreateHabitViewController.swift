//
//  CreateHabitViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit
import Combine

class CreateHabitViewController: UIViewController {
    @IBOutlet weak var habitsCollectionView: UICollectionView!
    @IBOutlet weak var examplesLabel: UILabel!
    private let viewModel = CreateHabitViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationTitle(title: "A new habit")
        setNaviagtionBackButton(image: .backButton)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: ((self.view.bounds.width - 54) / 2), height: 41)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 22
        habitsCollectionView.collectionViewLayout = layout
        habitsCollectionView.register(UINib(nibName: "HabitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HabitCollectionViewCell")
        habitsCollectionView.delegate = self
        habitsCollectionView.dataSource = self
        habitsCollectionView.allowsMultipleSelection = true
    }
    
    func subscribe() {
        viewModel.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] habits in
                guard let self = self else { return }
                self.examplesLabel.isHidden = habits.isEmpty
                self.habitsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedCreateHabit(_ sender: UIButton) {
        self.pushViewController(HabitFormViewController.self)
    }
    
    @IBAction func clickedNext(_ sender: UIButton) {
        if let indexSelectedItems = habitsCollectionView.indexPathsForSelectedItems {
            var habits: [HabitModel] = []
            for indexPath in indexSelectedItems {
                habits.append(viewModel.habits[indexPath.item])
            }
            viewModel.saveHabit(habitsModel: habits) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    viewModel.removeHabits(habits: habits)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension CreateHabitViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCell", for: indexPath) as! HabitCollectionViewCell
        cell.configure(habit: viewModel.habits[indexPath.item])
        return cell
    }
}
