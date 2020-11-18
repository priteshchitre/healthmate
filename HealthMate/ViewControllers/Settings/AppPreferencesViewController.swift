//
//  AppPreferencesViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit

class AppPreferencesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_APP_PREFERENCES), object: nil)
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "App_Preferences".toLocalize())
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
}
extension AppPreferencesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UnitMeasurementCell", for: indexPath) as! SettingsCell
            cell.contentLabel.text = "Unit_Measurement".toLocalize()
            cell.contentImageView.image = UIImage(named: "Unit_Measurement")
            return cell
        }
        if indexPath.row == 1 {

            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! SettingsCell
            cell.contentLabel.text = "Language".toLocalize()
            cell.contentImageView.image = UIImage(named: "Language")
            if let array = Global.languageArray.value(forKey: "LanguageCode") as? NSArray {
                let index = array.index(of: Global.getLanguageCode())
                if index < array.count {
                    cell.languageLabel.text = (Global.languageArray.object(at: index) as AnyObject).value(forKey: "LanguageName") as? String
                }
            }
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! SettingsCell
        cell.contentLabel.text = "Notification".toLocalize()
        cell.contentImageView.image = UIImage(named: "Notification")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "UnitViewController") as! UnitViewController
                self.navigationController?.pushViewController(view, animated: true)
            }
        }
        else if indexPath.row == 1 {
            DispatchQueue.main.async {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
                let navController = UINavigationController(rootViewController: view)
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
}
