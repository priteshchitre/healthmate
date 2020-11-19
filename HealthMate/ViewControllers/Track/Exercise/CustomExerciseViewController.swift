//
//  CustomExerciseViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 13/11/20.
//

import UIKit

class CustomExerciseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: RoundButton!
    
    var dataArray : [ExerciseClass] = []
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Custom_Exercises".toLocalize())
        self.createButton.setTitle("Create_Exercise".toLocalize(), for: UIControl.State.normal)
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        
        self.dataArray = ExerciseClass.getCustomExerciseArray()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func onCreateButtonTap(_ sender: Any) {
     
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CaloriesBurnedViewController") as! CaloriesBurnedViewController
        let obj = ExerciseClass()
        let timestamp = NSDate().timeIntervalSince1970
        obj.exerciseId = "\(timestamp)"
        obj.isCustomExercise = true
        view.exerciseObject = obj
        view.isAdd = true
        view.selectedDate = self.selectedDate
        self.navigationController?.pushViewController(view, animated: true)
    }
}
extension CustomExerciseViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return self.dataArray.count
        }
        return self.dataArray.count == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! FoodListCell
            let object = self.dataArray[indexPath.row]
            cell.bgView.layer.addCustomShadow()
            cell.titleLabel.text = object.name
            cell.caloriesLabel.text = "\(object.calorie.toRound()) \("calories_per_hour".toLocalize())"
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! FoodListCell
        cell.bgView.layer.addCustomShadow()
        cell.noDataLabel.text = "No_Custom_Exercises_Found".toLocalize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesDetailsViewController") as! ExerciseCaloriesDetailsViewController
            view.isFromRecent = false
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
                
                ExerciseClass.deleteRecord(self.dataArray[indexPath.row])
                self.dataArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            actionsheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
                
            }))
            self.present(actionsheet, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}
