//
//  LanguageViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 2/11/20.
//

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setBackBarButton(true)
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Language".toLocalize())
//        self.navigationController?.navigationBar.barTintColor = Color.disableGray
        self.setCancelBarButton()
        self.setDoneBarButton()
        
        let filterArray = Global.languageArray.filter { (obj) -> Bool in
            
            if let dic = obj as? NSDictionary {
                let str = AnyObjectRef(dic.value(forKey: "LanguageCode") as AnyObject).stringValue()
                if Global.getLanguageCode() == str {
                    return true
                }
            }
            return false
            
        }
        if filterArray.count > 0 {
            let index = Global.languageArray.index(of: filterArray[0])
            self.selectedRow = index
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    func setDoneBarButton() {
        
        let backButton : UIButton = UIButton()
        backButton.setTitle("Done".toLocalize(), for: UIControl.State.normal)
        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onDoneButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onDoneButtonTapped() {
        
        Global.setIsAppLanguageSet(true)
        let lanCode = (Global.languageArray.object(at: self.selectedRow) as AnyObject).value(forKey: "LanguageCode") as! String
        Global.setLanguageCode(lanCode)
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_DASHBOARD), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_SUBSCRIPTION), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_TRACK_VIEW), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_FOOD_LIST), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_FOOD_DETAILS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_CUSTOM_FOOD), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_PROGRESS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_RECIPE), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_RECIPE_DETAILS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_WORKOUT), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_WORKOUT_DETAILS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_SETTINGS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_EXCERCISE), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_SETTINGS), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_APP_PREFERENCES), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.LOCAL_USER_PROFILE), object: nil)
        let alert1 = UIAlertController(title: "Language_updated".toLocalize(), message: "", preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "OK".toLocalize(), style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert1.addAction(okAction)
        self.present(alert1, animated: true, completion: nil)
    }
}
extension LanguageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        let imageView = cell.viewWithTag(101) as! UIImageView
        label.text = (Global.languageArray.object(at: indexPath.row) as AnyObject).value(forKey: "LanguageName") as? String
        imageView.image = UIImage(named: "checkmark")?.image(withTintColor: Color.appOrange)
        if self.selectedRow == indexPath.row {
            imageView.isHidden = false
        }
        else {
            imageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        self.tableView.reloadData()
    }
}
