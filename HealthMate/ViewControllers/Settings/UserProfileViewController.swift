//
//  UserProfileViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 30/10/20.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_USER_PROFILE), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "User_Profile".toLocalize())
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
    
    func getCalorieCalculator() {
        
        if !Global.checkNetworkConnectivity() {
            Global.showNoNetworkAlert()
            return
        }
        
        var currentWeight = UserClass.getWeight()
        var goalWeight = UserClass.getExptectedWeight()
        var currentHeight = UserClass.getHeight()
        
        if UserClass.getWeightMeasurement().lowercased() != "kg" {
            currentWeight = currentWeight / 2.205
        }
        if UserClass.getExptectedWeightMeasurement().lowercased() != "kg" {
            goalWeight = goalWeight / 2.205
        }
        if UserClass.getHeightMeasurement().lowercased() != "cm" {
            currentHeight = currentHeight * 2.54
        }
        
        let param : NSMutableDictionary = [
            "currentWeightKg": currentWeight,
            "heightCm": currentHeight,
            "desiredWeightKg": goalWeight,
            "activityLevel": Global.getActivityLevel(),
            "sex": Global.getGender(),
            "age": Global.getAge()
        ]
        
        Global.showProgressHud()
        
        APIHelperClass.sharedInstance.postRequest("\(APIHelperClass.calorieCalculator)", parameters: param) { (result, error, statusCode) in
            
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    Global.createJSONDetails("calorieCalculator", jsonData: dataDic)
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        Global.sharedInstance.calorieCalculatorArray = CalorieCalculatorClass.initWithArray(dataArray)
                        let view = self.storyboard?.instantiateViewController(withIdentifier: "WeightPlanViewController") as! WeightPlanViewController
                        self.navigationController?.pushViewController(view, animated: true)
                        return
                    }
                }
            }
        }
    }
}
extension UserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! UserProfileCell
            cell.nameLabel.text = UserClass.getName()
            cell.bgView.layer.addCustomShadow()
            cell.profileLabel.text = "Update_Profile".toLocalize()
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! UserProfileCell
        if indexPath.row == 0 {
            cell.contentTitleLabel.text = "Gender".toLocalize()
            if UserClass.getGender() == "1" {
                cell.contentDetailLabel.text = "Male".toLocalize()
            }
            else if UserClass.getGender() == "2" {
                cell.contentDetailLabel.text = "Female".toLocalize()
            }
            else {
                cell.contentDetailLabel.text = "Non_Binary".toLocalize()
            }
        }
        else if indexPath.row == 1 {
            cell.contentTitleLabel.text = "Height".toLocalize()
            cell.contentDetailLabel.text = "\(Global.getConvertedHeight().toString()) \(UserClass.getSettingHeight())"
        }
        else if indexPath.row == 2 {
            cell.contentTitleLabel.text = "Activity".toLocalize()
            cell.contentDetailLabel.text = Global.getActivityArray()[UserClass.getActiveIndex()]
        }
        else if indexPath.row == 3 {
            cell.contentTitleLabel.text = "Current_weight".toLocalize()
            cell.contentDetailLabel.text = "\(Global.getConvertedWeight().toString()) \(UserClass.getSettingWeight())"
        }
        else if indexPath.row == 4 {
            cell.contentTitleLabel.text = "Weight Goal".toLocalize()
            cell.contentDetailLabel.text = "\(Global.getConvertedGoalWeight().toString()) \(UserClass.getSettingWeight())"
        }
        else {
            cell.contentTitleLabel.text = "Weight_Plan".toLocalize()
            
            let filterArray = Global.sharedInstance.calorieCalculatorArray.filter { (obj) -> Bool in
                return obj.action == UserClass.getGoalAction()
            }
            if filterArray.count > 0 {
                let object = filterArray[0]
                
                var weight = fabsf(object.value).toString()
                if UserClass.getSettingWeight() == "lb" {
                    weight = fabsf(object.value * 2.205).toString()
                }
                weight = "\(weight) \(UserClass.getSettingWeight()) a \("week".toLocalize())"
                
                if object.action == WEIGHT_PLAN.MILD_WEIGHT_GAIN.rawValue {
                    
                    cell.contentDetailLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.WEIGHT_GAIN.rawValue {

                    cell.contentDetailLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.CHALLENGING_WEIGHT_GAIN.rawValue {

                    cell.contentDetailLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.EXTREME_WEIGHT_GAIN.rawValue {

                    cell.contentDetailLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.MILD_WEIGHT_LOSS.rawValue {

                    cell.contentDetailLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.WEIGHT_LOSS.rawValue {

                    cell.contentDetailLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.CHALLENGING_WEIGHT_LOSS.rawValue {

                    cell.contentDetailLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
                }
                else if object.action == WEIGHT_PLAN.EXTREME_WEIGHT_LOSS.rawValue {

                    cell.contentDetailLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
                }
                else {
                    cell.contentDetailLabel.text = "Maintain_Best".toLocalize()
                }
            }
            else {
                cell.contentDetailLabel.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNameViewController") as! SettingsNameViewController
            self.navigationController?.pushViewController(view, animated: true)
        }
        else {
            if indexPath.row == 0 {
                
                DispatchQueue.main.async {

                    let actionSheet = UIAlertController(title: "Select_Gender".toLocalize(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "\("Male".toLocalize())", style: UIAlertAction.Style.default, handler: { (action) in
                        UserClass.setGender("1")
                        self.tableView.reloadData()
                    }))
                    actionSheet.addAction(UIAlertAction(title: "\("Female".toLocalize())", style: UIAlertAction.Style.default, handler: { (action) in
                        UserClass.setGender("2")
                        self.tableView.reloadData()
                    }))
                    actionSheet.addAction(UIAlertAction(title: "\("Non_Binary".toLocalize())", style: UIAlertAction.Style.default, handler: { (action) in
                        UserClass.setGender("0")
                        self.tableView.reloadData()
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
                        
                        self.tableView.reloadData()
                    }))
                    self.present(actionSheet, animated: true, completion: nil)
                }
            }
            else if indexPath.row == 1 {
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingsInputViewController") as! SettingsInputViewController
                view.selectedType = .HEIGHT
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if indexPath.row == 2 {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "ActivitySelectionViewController") as! ActivitySelectionViewController
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if indexPath.row == 3 {
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingsInputViewController") as! SettingsInputViewController
                view.selectedType = .WEIGHT
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if indexPath.row == 4 {
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingsInputViewController") as! SettingsInputViewController
                view.selectedType = .EXPRECTED_WEIGHT
                self.navigationController?.pushViewController(view, animated: true)
            }
            else if indexPath.row == 5 {
                
                self.getCalorieCalculator()
            }
        }
    }
}
