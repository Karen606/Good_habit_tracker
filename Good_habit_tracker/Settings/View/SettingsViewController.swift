//
//  SettingsViewController.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 12.11.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeSwitch: BaseSwitch!
    @IBOutlet weak var remindersSwitch: BaseSwitch!
    @IBOutlet weak var archiveSwitch: BaseSwitch!
    @IBOutlet weak var completedSwitch: BaseSwitch!
    @IBOutlet weak var missedSwitch: BaseSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setNaviagtionBackButton(image: .closeButton)
        let switches = [darkModeSwitch, remindersSwitch, archiveSwitch, completedSwitch, missedSwitch]
        switches.forEach({ $0?.layer.cornerRadius =  ($0?.frame.height ?? 0) / 2})
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        remindersSwitch.isOn = NotificationManager.shared.isNotificationEnabled()
        archiveSwitch.isOn = UserDefaults.standard.bool(forKey: "isArchiveEnabled")
        completedSwitch.isOn = UserDefaults.standard.bool(forKey: "isCompletedEnabled")
        missedSwitch.isOn = UserDefaults.standard.bool(forKey: "isMissedEnabled")

    }
    
    @IBAction func clickedDarkMode(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }
    
    @IBAction func clickedReminders(_ sender: BaseSwitch) {
        if sender.isOn {
            NotificationManager.shared.requestNotificationPermission(completion: { granted in
                sender.isOn = granted
                sender.setOn(granted, animated: true)
                UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
            })
        } else {
            print("Notifications disabled")
            sender.isOn = false
            UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
        }
    }
    
    @IBAction func clickedArchive(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "isArchiveEnabled")
    }
    
    @IBAction func clickedCompleted(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "isCompletedEnabled")
    }
    
    @IBAction func clickedMissed(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "isMissedEnabled")
    }
    
    

    @IBAction func clickedContactUs(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["alina.sverlova6@icloud.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
//
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        privacyVC.url = URL(string: "https://docs.google.com/document/d/1p_yBtClAhyrHDqzp_F3CzFggKrz-a5PItc2JKsjXrhU/mobilebasic")
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
//
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6742742223"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }
}

//
//extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

