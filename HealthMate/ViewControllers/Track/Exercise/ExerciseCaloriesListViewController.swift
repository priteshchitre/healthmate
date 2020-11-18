//
//  ExerciseCaloriesListViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit

class ExerciseCaloriesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var eatenDataArray : [ExerciseClass] = []
    var todayBurnedDataArray : [BurnedClass] = []
    var exerciseArray : [ExerciseClass] = []
    var dataArray : [ExerciseClass] = []
    var isMyFood : Bool = false
    var burnedDataArray : [BurnedClass] = []
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateConsumedData()
    }
    
    @objc func updateConsumedData() {
        
        self.exerciseArray = ExerciseClass.getExerciseArray()
        self.burnedDataArray = BurnedClass.getBurnedArray()
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        let dateString = formatter.string(from: self.selectedDate)
        self.todayBurnedDataArray = self.burnedDataArray.filter { (obj) -> Bool in
            return dateString == obj.date
        }
        self.eatenDataArray = []
        for obj in self.todayBurnedDataArray {
            self.eatenDataArray.append(obj.exerciseObject)
        }
        if self.isMyFood {
            self.dataArray = self.exerciseArray
        }
        else {
            self.dataArray = self.eatenDataArray
        }
        self.tableView.reloadData()
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Recently_Performed".toLocalize())
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
    
    @objc func onEatenTodayButtonTap() {
        
        self.isMyFood = false
        self.dataArray = self.eatenDataArray
        self.tableView.reloadData()
    }
    
    @objc func onMyFoodButtonTap() {
        
        self.dataArray = self.exerciseArray
        self.isMyFood = true
        self.tableView.reloadData()
    }
}
extension ExerciseCaloriesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        if section == 1 {
            return self.dataArray.count
        }
        return self.dataArray.count == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! FoodListCell
            
            cell.eatenTodayButton.layer.cornerRadius = 5
            cell.myFoodButton.layer.cornerRadius = 5
            cell.eatenTodayButton.setTitle("Performed_Today".toLocalize(), for: UIControl.State.normal)
            cell.myFoodButton.setTitle("My_Exercise".toLocalize(), for: UIControl.State.normal)
            
            if self.isMyFood {
                cell.eatenTodayButton.backgroundColor = Color.disableGray
                cell.myFoodButton.backgroundColor = Color.appOrange
            }
            else {
                cell.eatenTodayButton.backgroundColor = Color.appOrange
                cell.myFoodButton.backgroundColor = Color.disableGray
            }
            cell.eatenTodayButton.addTarget(self, action: #selector(self.onEatenTodayButtonTap), for: UIControl.Event.touchUpInside)
            cell.myFoodButton.addTarget(self, action: #selector(self.onMyFoodButtonTap), for: UIControl.Event.touchUpInside)
            return cell
        }
        if indexPath.section == 1 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! FoodListCell
            let object = self.dataArray[indexPath.row]
            cell.bgView.layer.addCustomShadow()
            
            if self.isMyFood {
                cell.titleLabel.text = object.name
                cell.caloriesLabel.text = "\(object.calorie.toString()) \("calories".toLocalize())"
            }
            else {
                
                if object.isWorkout {
                    cell.titleLabel.text = "\(object.name)\n-\("Workouts".toLocalize())"
                }
                else {
                    cell.titleLabel.text = object.name
                }
                let totalCalories = self.todayBurnedDataArray[indexPath.row].calories
                cell.caloriesLabel.text = "\(totalCalories.toString()) \("calories".toLocalize())"
            }
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! FoodListCell
        cell.bgView.layer.addCustomShadow()
        if self.isMyFood {
            cell.noDataLabel.text = "Your_exercise_will_appear_here".toLocalize()
        }
        else {
            cell.noDataLabel.text = "Your_performed_exercise_will_appear_here".toLocalize()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesDetailsViewController") as! ExerciseCaloriesDetailsViewController
            
            if self.isMyFood {
                view.isFromRecent = false
            }
            else {
                view.isFromRecent = true
                view.burnedObject = self.todayBurnedDataArray[indexPath.row]
                view.duration = self.todayBurnedDataArray[indexPath.row].duration
                view.activityObject = self.todayBurnedDataArray[indexPath.row].activityObject
            }
            view.exerciseObject = self.dataArray[indexPath.row]
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete".toLocalize()) { (action, indexPath1) in
            
            let actionsheet = UIAlertController(title: "Are_you_sure_you_want_to_remove_selected_exercise".toLocalize(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
            actionsheet.addAction(UIAlertAction(title: "Delete".toLocalize(), style: UIAlertAction.Style.destructive, handler: { (action) in
                
                BurnedClass.deleteRecord(self.todayBurnedDataArray[indexPath.row])
                self.updateConsumedData()
            }))
            actionsheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
                
            }))
            self.present(actionsheet, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}
