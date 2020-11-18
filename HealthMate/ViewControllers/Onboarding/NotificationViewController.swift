//
//  NotificationViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 27/10/20.
//

import UIKit
import OneSignal

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.openInitialAlert()
        }
    }
    
    func initView() {
        
        self.titleLabel.text = "Get_Daily_Reminders".toLocalize()
        self.subTitleLabel.text = "notification_message_subtitle".toLocalize()
        
        self.continueButton.setTitle("Turn_on_notifications".toLocalize(), for: UIControl.State.normal)
        self.skipButton.setTitle("Maybe_later".toLocalize(), for: UIControl.State.normal)
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//
//            if granted == true && error == nil {
//            }
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
//            }
//
//        }
        self.notificationTap()
    }
    
    @IBAction func onSkipButtonTap(_ sender: Any) {
        
        self.moveToNext()
    }
    
    func moveToNext() {
        
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
    func openSettingAlert() {
        
        let alert = UIAlertController(title: "Notifications_are_turned_off".toLocalize(), message: "Notifications_are_turned_off_message".toLocalize(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            self.moveToNext()
        }))
        alert.addAction(UIAlertAction(title: "Open_Settings".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            DispatchQueue.main.async {
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openInitialAlert() {
        
        let alert = UIAlertController(title: "Get_Daily_Reminders".toLocalize(), message: "notification_message_subtitle".toLocalize(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dont_Allow".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Allow".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            self.notificationTap()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func notificationTap() {
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            
            if accepted {
                self.moveToNext()
            }
            else {
                DispatchQueue.main.async {
                    self.openSettingAlert()
                }
            }
        })
    }
}
