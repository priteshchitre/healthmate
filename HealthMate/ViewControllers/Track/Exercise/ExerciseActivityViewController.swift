//
//  ExerciseActivityViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 17/11/20.
//

import UIKit

class ExerciseActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [ActivityClass] = []
    var object = ExerciseCategoryClass()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initElements()
    }
    
    func initView() {

        self.setNavigationBar()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: object.category.capitalized)
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
extension ExerciseActivityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = self.dataArray[indexPath.row]
        let bgView = cell.viewWithTag(100)!
        let titleLabel = cell.viewWithTag(101) as! UILabel
        let subTitleLabel = cell.viewWithTag(102) as! UILabel
        bgView.layer.addCustomShadow()
        titleLabel.text = object.name.capitalized
        subTitleLabel.text = "\(object.burnedCalories.toString()) \("calories".toLocalize()) \("per".toLocalize()) \(object.durationMin) \("minutes".toLocalize())"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesDetailsViewController") as! ExerciseCaloriesDetailsViewController
        let activityObject = self.dataArray[indexPath.row]
        
        let obj = ExerciseClass()
        let timestamp = NSDate().timeIntervalSince1970
        obj.name = activityObject.name
        obj.exerciseId = "\(timestamp)"
        obj.isSearchExercise = true
        
        view.isFromRecent = false
        view.exerciseObject = obj
        
        view.selectedDate = self.selectedDate
        view.duration = activityObject.durationMin
        view.activityObject = activityObject
        self.navigationController?.pushViewController(view, animated: true)
    }
}
