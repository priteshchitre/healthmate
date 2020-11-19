//
//  ExerciseCaloriesDetailsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit
import ActionSheetPicker_3_0

class ExerciseCaloriesDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: RoundButton!
    
    var exerciseObject = ExerciseClass()
    var selectedDate = Date()
    var isFromRecent : Bool = false
    var burnedObject = BurnedClass()
    var duration : Int = 30
    var activityObject = ActivityClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshExerciseCaloriesDetails(_:)), name: NSNotification.Name("ExerciseCaloriesDetailsRefresh"), object: nil)
        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Exercise".toLocalize())
        self.editButton.setTitle("Edit_Exercise".toLocalize(), for: UIControl.State.normal)
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setAteButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if self.exerciseObject.isWorkout || self.exerciseObject.isSearchExercise {
            self.editButton.isHidden = true
        }
        else {
            self.editButton.isHidden = false
        }
    }
    
    func initElements() {
        
    }
    
    @objc func refreshExerciseCaloriesDetails(_ notification : Notification) {
        
        if let obj = notification.object as? ExerciseClass {
            self.exerciseObject = obj
        }
        self.tableView.reloadData()
    }
    
    func setAteButton() {
        
        let backButton : UIButton = UIButton()
        
        if self.isFromRecent {
            backButton.setTitle("Update".toLocalize(), for: UIControl.State.normal)
        }
        else {
            backButton.setTitle("I_Did_This".toLocalize(), for: UIControl.State.normal)
        }
        
        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        backButton.addTarget(self, action: #selector(self.onAteButtonTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onAteButtonTap() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        if !self.isFromRecent {
            let timestamp = NSDate().timeIntervalSince1970
            self.burnedObject.burnedId = "\(timestamp)"
        }
        else {
//            if self.burnedObject.date != formatter.string(from: self.selectedDate) {
//                let timestamp = NSDate().timeIntervalSince1970
//                self.burnedObject.burnedId = "\(timestamp)"
//            }
        }
        
        self.burnedObject.duration = self.duration
        self.burnedObject.isCustomExercise = self.exerciseObject.isCustomExercise
        self.burnedObject.date = formatter.string(from: self.selectedDate)
        if self.exerciseObject.isCustomExercise {
            
            let burnCalorie = self.exerciseObject.calorie / 60 * Float(self.duration)
            self.burnedObject.calories = burnCalorie
        }
        else if self.exerciseObject.isSearchExercise {
            
            let burnCalorie = self.activityObject.burnedCalories * Float(self.duration) / Float(self.activityObject.durationMin)
            self.burnedObject.calories = burnCalorie
        }
        else {
            self.burnedObject.calories = self.exerciseObject.calorie
        }
        
        
        BurnedClass.updateRecord(self.burnedObject, exerciseObject: self.exerciseObject, activityObject: self.activityObject)
        NotificationCenter.default.post(name: NSNotification.Name("DismissExerciseView"), object: nil)
        //        if self.isFromRecent {
        //            _ = self.navigationController?.popToRootViewController(animated: true)
        //        }
        //        else {
        //            _ = self.navigationController?.popViewController(animated: true)
        //        }
    }
    
    @IBAction func onEditButtonTap(_ sender: Any) {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CaloriesBurnedViewController") as! CaloriesBurnedViewController
        view.exerciseObject = self.exerciseObject
        self.navigationController?.pushViewController(view, animated: true)
    }
}
extension ExerciseCaloriesDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if self.exerciseObject.isCustomExercise || self.exerciseObject.isSearchExercise {
                return 1
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            cell.titleLabel.text = self.exerciseObject.name
            if self.exerciseObject.isCustomExercise {
                cell.sizeLabel.text = "\(self.exerciseObject.calorie.toRound()) \("calories_per_hour".toLocalize())"
            }
            else if self.exerciseObject.isSearchExercise {
                cell.sizeLabel.text = "\(self.activityObject.burnedCalories.toRound()) \("calories".toLocalize()) \("per".toLocalize()) \(self.activityObject.durationMin) \("minutes".toLocalize())"
            }
            else {
                cell.sizeLabel.text = "\(self.exerciseObject.calorie.toRound()) \("calories".toLocalize())"
            }
            
            return cell
        }
        if indexPath.section == 1 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ServingCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            cell.titleLabel.text = "Duration".toLocalize()
            cell.servingLabel.text = "\(self.duration) \("minutes".toLocalize())"
            return cell
        }
        if indexPath.section == 2 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ServingCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            cell.titleLabel.text = "Date".toLocalize()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            let today = formatter.string(from: Date())
            let selectedDate = formatter.string(from: self.selectedDate)
            if today == selectedDate {
                cell.servingLabel.text = "Today".toLocalize()
            }
            else {
                formatter.dateFormat = "MMM dd"
                cell.servingLabel.text = formatter.string(from: self.selectedDate)
            }
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! FoodDetailsCell
        
        cell.bgView.layer.addCustomShadow()
        var totalCalories = self.exerciseObject.calorie
        if self.exerciseObject.isCustomExercise {
            totalCalories = self.exerciseObject.calorie / 60 * Float(self.duration)
        }
        else if self.exerciseObject.isSearchExercise {
            totalCalories = self.activityObject.burnedCalories * Float(self.duration) / Float(self.activityObject.durationMin)
        }
        
        let str1 = "Total_Calories".toLocalize()
        let str2 = "-\(totalCalories.toRound())"
        cell.totalCalories.text = "\(str1) \(str2)"
        
        let attr1 = NSMutableAttributedString(string: cell.totalCalories.text!)
        
        let matchRange1 = (cell.totalCalories.text! as NSString).range(of: str2)
        attr1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 211, green: 47, blue: 65) , range: matchRange1)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.customFont(name: Font.RobotoBold, size: 18) , range: matchRange1)
        
        cell.totalCalories.attributedText = attr1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let datePicker = ActionSheetDatePicker(title: "Duration".toLocalize(), datePickerMode: UIDatePicker.Mode.countDownTimer, selectedDate: Date(), doneBlock: { (picker, value, index) in
                
                if let seconds = value as? Int {
                    self.duration = seconds / 60
                }
                self.tableView.reloadData()
            }, cancel: { (picker) in
                
            }, origin: self.view)
            if #available(iOS 13.4, *) {
                datePicker?.datePickerStyle = .wheels
            }
            datePicker?.countDownDuration = TimeInterval(self.duration * 60)
            datePicker?.show()
            
        }
        else if indexPath.section == 2 {
            
            let datePicker = ActionSheetDatePicker(title: "Date".toLocalize(), datePickerMode: UIDatePicker.Mode.date, selectedDate: self.selectedDate, doneBlock: { (picker, value, index) in
                
                if let date = value as? Date {
                    self.selectedDate = date
                }
                self.tableView.reloadData()
            }, cancel: { (picker) in
                
            }, origin: self.view)
            if #available(iOS 13.4, *) {
                datePicker?.datePickerStyle = .wheels
            }
            
            datePicker?.show()
        }
    }
}
