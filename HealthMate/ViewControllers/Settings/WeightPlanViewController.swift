//
//  WeightPlanViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 11/11/20.
//

import UIKit

class WeightPlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Weight_Plan".toLocalize())
        self.setDoneBarButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.selectedIndex = -1
        if Global.sharedInstance.calorieCalculatorArray.count == 1 {
            self.selectedIndex = 1
        }
        self.tableView.reloadData()
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
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        backButton.titleLabel?.textAlignment = .right
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onDoneButtonTapped() {
        
        if self.selectedIndex == -1 {
            return
        }
        UserClass.setGoalAction(Global.sharedInstance.calorieCalculatorArray[self.selectedIndex].action)
        UserClass.setGoalCalories(Global.sharedInstance.calorieCalculatorArray[self.selectedIndex].calories)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
extension WeightPlanViewController : UITableViewDelegate, UITableViewDataSource {
    
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
        if UserClass.getSettingWeight() == "lb" {
            weight = fabsf(object.value * 2.205).toString()
        }
        weight = "\(weight) \(UserClass.getSettingWeight()) a \("week".toLocalize())"
        
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
    }
}
