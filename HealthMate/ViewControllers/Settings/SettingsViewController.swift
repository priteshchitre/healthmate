//
//  SettingsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import MessageUI
import SafariServices
import StoreKit

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var titleArray : [String] = []
    var imageArray : [String] = ["User_edit", "Share", "Rate_app", "EULA", "Support", "Privacy_Policy", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_SETTINGS), object: nil)
    }
    
    @objc func initLocal() {
        
        self.titleArray = ["App_Preferences".toLocalize(), "Share".toLocalize(), "Rate_this_app".toLocalize(), "EULA".toLocalize(), "Support".toLocalize(), "Privacy_Policy".toLocalize(), "Logout".toLocalize()]
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Setting".toLocalize())
        self.tableView.reloadData()
    }

    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
}
extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! SettingsCell
            cell.nameLabel.text = UserClass.getName()
            cell.bgView.layer.addCustomShadow()
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! SettingsCell
        cell.contentLabel.text = self.titleArray[indexPath.row]
        cell.contentImageView.image = UIImage(named: self.imageArray[indexPath.row])
        if indexPath.row == self.titleArray.count - 1 {
            cell.contentViewBottom.constant = 2
        }
        else {
            cell.contentViewBottom.constant = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(view, animated: true)
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "AppPreferencesViewController") as! AppPreferencesViewController
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if indexPath.row == 1 { //Share

                let text = "Check out the HealthMate: Calorie Counter that help me track my progress daily!"
                let url = URL(string: Constants.APP_URL)!
                let textShare = [ text, url ] as [Any]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            else if indexPath.row == 2 { //Rate
                
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(Constants.APP_ID)?mt=8&action=write-review" ) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            else if indexPath.row == 3 { //EULA

                let url = URL(string: Constants.EULA)!
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            }
            else if indexPath.row == 4 { //Support

                //TODO:  You should chack if we can send email or not
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([Constants.SUPPORT_EMAIL])
                    mail.setSubject("Support Required")
                    self.present(mail, animated: true)
                } else {
                    Global.showError("Your device could not send e-mail. Please check e-mail configuration and try again.")
                }
            }
            else if indexPath.row == 5 { //Privacy Policy

                let url = URL(string: Constants.PRIVACY_POLICY)!
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            }
            else if indexPath.row == 6 { //Logout
                
                DispatchQueue.main.async {

                    let alert = UIAlertController(title: "logout_confirm_title".toLocalize(), message: "logout_confirm_message".toLocalize(), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Logout".toLocalize(), style: UIAlertAction.Style.destructive, handler: { (action) in
                        
                        UserClass.resetUser()
                        Global.openGetStarted()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
//extension SettingsViewController:UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
