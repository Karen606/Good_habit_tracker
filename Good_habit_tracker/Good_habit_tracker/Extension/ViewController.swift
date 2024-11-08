//
//  ViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

extension UIViewController {
    
    func setNavigationTitle(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .text
        titleLabel.font = .alternatesRegular(size: 33)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func setNaviagtionBackButton(image: UIImage) {
        let backButton = UIButton(type: .custom)
        backButton.setImage(image, for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setNaviagtionArchiveButton(image: UIImage) {
        let archiveButton = UIButton(type: .custom)
        archiveButton.setImage(UIImage.archive, for: .normal)
        archiveButton.addTarget(self, action: #selector(clickedArchive), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: archiveButton)
    }
    
    func setNaviagtionCalendarButton(button: UIButton) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func clickedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func clickedArchive() {
        
    }
    
    func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        let nibName = String(describing: viewControllerType)
        let viewController = T(nibName: nibName, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func setAsRoot() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first else {
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            })
        } else {
            window.rootViewController = viewController
        }
        
        window.makeKeyAndVisible()
    }
}

