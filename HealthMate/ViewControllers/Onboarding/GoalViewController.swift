//
//  GoalViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class GoalViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: RoundButton!
    
//    var titleArray : [String] = ["Easy".toLocalize(), "Moderate".toLocalize(), "Challenging".toLocalize(), "Extreme".toLocalize()]
//    var detailArray : [Float] = [0.25, 0.50, 0.75, 1.0]
//    var caloriesArray : [Float] = [2000, 1700, 1400, 1200]
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.selectedIndex = -1
        if Global.sharedInstance.calorieCalculatorArray.count == 1 {
            self.selectedIndex = 1
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initView() {
        
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        self.titleLabel.text = "How_do_you_want_to_archive_your_goal".toLocalize()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.continueButton.backgroundColor = Color.disableGray
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
//        let view = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        self.navigationController?.pushViewController(view, animated: true)
        
        if self.selectedIndex == -1 {
            return
        }
        UserClass.setGoalAction(Global.sharedInstance.calorieCalculatorArray[self.selectedIndex].action)
        UserClass.setGoalCalories(Global.sharedInstance.calorieCalculatorArray[self.selectedIndex].calories)
        
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
}
extension GoalViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.sharedInstance.calorieCalculatorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let titleLabel = cell.viewWithTag(100) as! UILabel
        let detailsLabel = cell.viewWithTag(101) as! UILabel
        let caloriesLabel = cell.viewWithTag(103) as! UILabel
        let bgView = cell.viewWithTag(102)!
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 5
        bgView.layer.borderWidth = 0.25
        bgView.layer.borderColor = UIColor.white.cgColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOffset = CGSize.zero // Use any CGSize
        bgView.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
        
        let object = Global.sharedInstance.calorieCalculatorArray[indexPath.row]

        var weight = fabsf(object.value).toString()
        if UserClass.getWeightMeasurement() == "lb" {
            weight = fabsf(object.value * 2.205).toString()
        }
        weight = "\(weight) \(UserClass.getWeightMeasurement()) a \("week".toLocalize())"
        
        if object.action == WEIGHT_PLAN.MILD_WEIGHT_GAIN.rawValue {
            
            titleLabel.text = "Easy".toLocalize()
            detailsLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.WEIGHT_GAIN.rawValue {

            titleLabel.text = "Moderate".toLocalize()
            detailsLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.CHALLENGING_WEIGHT_GAIN.rawValue {

            titleLabel.text = "Challenging".toLocalize()
            detailsLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.EXTREME_WEIGHT_GAIN.rawValue {

            titleLabel.text = "Extreme".toLocalize()
            detailsLabel.text = "\("Gain_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.MILD_WEIGHT_LOSS.rawValue {

            titleLabel.text = "Easy".toLocalize()
            detailsLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.WEIGHT_LOSS.rawValue {

            titleLabel.text = "Moderate".toLocalize()
            detailsLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.CHALLENGING_WEIGHT_LOSS.rawValue {

            titleLabel.text = "Challenging".toLocalize()
            detailsLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
        }
        else if object.action == WEIGHT_PLAN.EXTREME_WEIGHT_LOSS.rawValue {

            titleLabel.text = "Extreme".toLocalize()
            detailsLabel.text = "\("Lose_up_to".toLocalize()) \(weight)"
        }
        else {
            titleLabel.text = "Maintain_Best".toLocalize()
            detailsLabel.text = ""
        }
        caloriesLabel.text = "\(object.calories.toString()) Cal"
        
        if self.selectedIndex == indexPath.row {
            bgView.backgroundColor = Color.appOrange
            caloriesLabel.textColor = UIColor.black
        }
        else {
            bgView.backgroundColor = UIColor.white
            caloriesLabel.textColor = Color.appOrange
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        self.continueButton.backgroundColor = Color.roundButtonColor
    }
}
