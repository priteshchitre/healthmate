//
//  FinishWorkoutViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 11/11/20.
//

import UIKit

class FinishWorkoutViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var addButton: RoundButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var object = WorkoutClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setBackBarButton(true)
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Workout_Completed".toLocalize())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let str1 = "You_just_burned".toLocalize()
        let str2 = self.object.calorie.toString()
        let str3 = "calories".toLocalize()
        
        self.topLabel.text = "\(str1)\n\(str2)\n\(str3)"

        let attr1 = NSMutableAttributedString(string: self.topLabel.text!)
        
        let matchRange1 = (self.topLabel.text! as NSString).range(of: str1)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.customFont(name: Font.RobotoMedium, size: 18) , range: matchRange1)

        let matchRange2 = (self.topLabel.text! as NSString).range(of: str2)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.customFont(name: Font.RobotoBold, size: 30) , range: matchRange2)
        attr1.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.appOrange, range: matchRange2)
        
        let matchRange3 = (self.topLabel.text! as NSString).range(of: str2)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.customFont(name: Font.RobotoBold, size: 25) , range: matchRange3)
        
        self.topLabel.attributedText = attr1
        
        self.addButton.setTitle("Add_to_Exercise_Diary".toLocalize(), for: UIControl.State.normal)
        self.noButton.setTitle("No_thank_you".toLocalize(), for: UIControl.State.normal)
    }
    
    @IBAction func onAddButtonTap(_ sender: Any) {

        let obj = ExerciseClass()
        let timestamp = NSDate().timeIntervalSince1970
        obj.exerciseId = "\(timestamp)"
        obj.name = self.object.title
        obj.calorie = self.object.calorie
        obj.isWorkout = true
        
        let burnObj = BurnedClass()
        burnObj.burnedId = "\(timestamp)"
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        burnObj.date = formatter.string(from: Date())
        burnObj.calories = self.object.calorie
        burnObj.isWorkout = true
        
        ExerciseClass.updateRecord(obj)
        BurnedClass.updateRecord(burnObj, exerciseObject: obj, activityObject: ActivityClass())
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onNoThankyouButtonTap(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
extension FinishWorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object.workoutExerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        let calorieLabel = cell.viewWithTag(101) as! UILabel
        label.text = self.object.workoutExerciseArray[indexPath.row].title
        calorieLabel.text = "\(self.object.workoutExerciseArray[indexPath.row].calorie.toString()) \("calories".toLocalize())"
        return cell
    }
}
