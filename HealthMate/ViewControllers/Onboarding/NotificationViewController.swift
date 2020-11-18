//
//  NotificationViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 27/10/20.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        self.titleLabel.text = "Get_Daily_Reminders".toLocalize()
        self.subTitleLabel.text = "notification_message_subtitle".toLocalize()
        
        self.continueButton.setTitle("Turn_on_notifications".toLocalize(), for: UIControl.State.normal)
        self.skipButton.setTitle("Maybe_later".toLocalize(), for: UIControl.State.normal)
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted == true && error == nil {
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
            }

        }
    }
    
    @IBAction func onSkipButtonTap(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
}
