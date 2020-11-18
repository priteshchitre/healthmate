//
//  SearchExerciseViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 17/11/20.
//

import UIKit

class SearchExerciseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [ExerciseCategoryClass] = []
    var mainDataArray : [ExerciseCategoryClass] = []
    var mainCustomArray : [ExerciseClass] = []
    var customArray : [ExerciseClass] = []
    
    var searchBar: UISearchBar = UISearchBar()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
    }
    
    func initView() {

        self.setNavigationBar()
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 44)
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.barTintColor = Color.appOrange
        self.searchBar.placeholder = "Search_Exercises".toLocalize()
        self.searchBar.delegate = self
        self.searchBar.tintColor = Color.appOrange
        self.searchBar.showsCancelButton = true
        
        self.navigationItem.titleView = self.searchBar

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.searchBar.becomeFirstResponder()
        
        self.getExerciseCategory()
        self.mainCustomArray = ExerciseClass.getCustomExerciseArray()
    }
    
    func initElements() {
        
    }
    
    func updateSearchRecord(_ searchText : String)  {
        
//        self.dataArray = self.mainDataArray
        if searchText != "" {
            
            let filter1 = self.mainDataArray.filter { (obj) -> Bool in
                return obj.activity.lowercased().contains(searchText.lowercased())
            }
            self.dataArray = filter1
            let filter2 = self.mainCustomArray.filter { (obj) -> Bool in
                return obj.name.lowercased().contains(searchText.lowercased())
            }
            self.customArray = filter2
        }
        else {
            self.customArray = []
            self.dataArray = []
        }
        
        self.tableView.reloadData()
    }
    
    func getExerciseCategory() {
        
        if !Global.checkNetworkConnectivity() {
            self.getLocalExerciseCategory()
            return
        }
        
        let param : NSMutableDictionary = NSMutableDictionary()
        
        DispatchQueue.main.async {
            Global.showProgressHud()
        }
        
        APIHelperClass.sharedInstance.getRequest("\(APIHelperClass.activities)", parameters: param) { (result, error, statusCode) in

            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    Global.createJSONDetails("ExerciseCategory", jsonData: dataDic)
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        self.mainDataArray = ExerciseCategoryClass.initWithArray(dataArray)
                    }
                }
            }
            self.updateSearchRecord("")
        }
    }
    
    func getLocalExerciseCategory() {
        
        if let dataDic = Global.getFileDetails("ExerciseCategory") {
            if let array = dataDic.value(forKey: "data") as? NSArray {
                self.mainDataArray = ExerciseCategoryClass.initWithArray(array)
            }
        }
        self.updateSearchRecord("")
    }
    
    func getActivityQuery(obj : ExerciseCategoryClass) {
        
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
            "weightKg": currentWeight,
            "heightCm": currentHeight,
            "sex": Global.getGender(),
            "age": Global.getAge(),
            "query": obj.activity
        ]
        
        DispatchQueue.main.async {
            Global.showProgressHud()
        }
        
        APIHelperClass.sharedInstance.postRequest("\(APIHelperClass.activitiesQuery)", parameters: param) { (result, error, statusCode) in

            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        let array = ActivityClass.initWithArray(dataArray)
                        if array.count > 0 {
                            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseActivityViewController") as! ExerciseActivityViewController
                            view.dataArray = array
                            view.selectedDate = self.selectedDate
                            view.object = obj
                            self.navigationController?.pushViewController(view, animated: true)
                        }
                    }
                }
            }
        }
    }
}
extension SearchExerciseViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.dataArray.count
        }
        if section == 1 {
            return self.customArray.count
        }
        if searchBar.text == "" {
            return 0
        }
        return (self.dataArray.count + self.customArray.count) == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let object = self.dataArray[indexPath.row]
            let bgView = cell.viewWithTag(100)!
            let titleLabel = cell.viewWithTag(101) as! UILabel
            bgView.layer.addCustomShadow()
            titleLabel.text = object.activity
            return cell
        }
        if indexPath.section == 1 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let object = self.customArray[indexPath.row]
            let bgView = cell.viewWithTag(100)!
            let titleLabel = cell.viewWithTag(101) as! UILabel
            bgView.layer.addCustomShadow()
            titleLabel.text = object.name
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath)
        let bgView = cell.viewWithTag(100)!
        let noDataLabel = cell.viewWithTag(101) as! UILabel
        bgView.layer.addCustomShadow()
        noDataLabel.text = "No_result_found".toLocalize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            self.searchBar.resignFirstResponder()
            self.getActivityQuery(obj: self.dataArray[indexPath.row])
        }
        else if indexPath.section == 1 {
            
            self.searchBar.resignFirstResponder()
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesDetailsViewController") as! ExerciseCaloriesDetailsViewController
            view.isFromRecent = false
            view.exerciseObject = self.customArray[indexPath.row]
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
extension SearchExerciseViewController : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.updateSearchRecord(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.text = ""
        self.updateSearchRecord("")
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
