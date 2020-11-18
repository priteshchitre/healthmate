//
//  FoodListViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit

class FoodListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: RoundButton!
    
    var eatenDataArray : [FoodClass] = []
    var todayConsumedDataArray : [ConsumeClass] = []
    var foodArray : [FoodClass] = []
    var dataArray : [FoodClass] = []
    var selectedMealString = ""
    var selectedMeal : Int = 0
    var isMyFood : Bool = false
    var consumedDataArray : [ConsumeClass] = []
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_FOOD_LIST), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateConsumedData()
    }
    
    @objc func updateConsumedData() {
        
        self.foodArray = FoodClass.getFoodArray()
        self.consumedDataArray = ConsumeClass.getConsumeArray()
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        let dateString = formatter.string(from: self.selectedDate)
        self.todayConsumedDataArray = self.consumedDataArray.filter { (obj) -> Bool in
            return dateString == obj.date && obj.mealType == self.selectedMeal
        }
        self.eatenDataArray = []
        for obj in self.todayConsumedDataArray {
            self.eatenDataArray.append(obj.foodObject)
        }
        
//        if self.isMyFood {
//            self.dataArray = self.foodArray
//        }
//        else {
//            self.dataArray = self.eatenDataArray
//        }
//        self.tableView.reloadData()
        self.updateSearchRecord(self.searchBar.text!)
    }
    
    func updateSearchRecord(_ searchText : String)  {
        
        if self.isMyFood {
            self.dataArray = self.foodArray
        }
        else {
            self.dataArray = self.eatenDataArray
        }
        
        if searchText != "" {

            let filter1 = self.dataArray.filter { (obj) -> Bool in
                return obj.foodName.lowercased().contains(searchText.lowercased())
            }
            self.dataArray = filter1
        }
        
        self.tableView.reloadData()
        
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: self.selectedMealString)
        self.createButton.setTitle("Create_New_Food".toLocalize(), for: UIControl.State.normal)
        self.searchBar.placeholder = "What_did_you_eat_today".toLocalize()
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        
        self.searchBar.delegate = self
        self.searchBar.tintColor = Color.appOrange
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
        self.updateSearchRecord(self.searchBar.text!)
    }
    
    @objc func onMyFoodButtonTap() {
        
        self.isMyFood = true
        self.updateSearchRecord(self.searchBar.text!)
    }
    
    @IBAction func onCreateButtonTap(_ sender: Any) {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CustomFoodViewController") as! CustomFoodViewController
        let obj = FoodClass()
        let timestamp = NSDate().timeIntervalSince1970
        obj.foodId = "\(timestamp)"
        view.foodObject = obj
        view.isAdd = true
        self.navigationController?.pushViewController(view, animated: true)
    }
}
extension FoodListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return self.dataArray.count
        }
        return self.dataArray.count == 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! FoodListCell
//            cell.searchView.layer.borderWidth = 2
//            cell.searchView.layer.borderColor = UIColor.black.cgColor
//            cell.searchView.layer.cornerRadius = 5
//            cell.searchTextField.placeholder = "What_did_you_eat_today".toLocalize()
//            cell.searchImageView.maskWith(color: Color.appGray)
            
            cell.eatenTodayButton.layer.cornerRadius = 5
            cell.myFoodButton.layer.cornerRadius = 5
            cell.eatenTodayButton.setTitle("Eaten_Today".toLocalize(), for: UIControl.State.normal)
            cell.myFoodButton.setTitle("My_Food".toLocalize(), for: UIControl.State.normal)
            
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
            cell.titleLabel.text = object.foodName
            if self.isMyFood {
                cell.sizeLabel.text = "\("Serving_Size".toLocalize()) : \(object.servingType)"
                cell.caloriesLabel.text = "\("Calories_per_serving".toLocalize()) : \(object.calorie.toString())"
            }
            else {
                let servings = self.todayConsumedDataArray[indexPath.row].servings
                let totalCalories = object.calorie * servings
                cell.sizeLabel.text = "\(servings.toString()) \("servings".toLocalize())"
                cell.caloriesLabel.text = "\(totalCalories.toString()) \("calories".toLocalize())"
            }

            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! FoodListCell
        cell.bgView.layer.addCustomShadow()
        if self.isMyFood {
            cell.noDataLabel.text = "Your_foods_will_appear_here".toLocalize()
        }
        else {
            cell.noDataLabel.text = "Your_eaten_foods_will_appear_here".toLocalize()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as! FoodDetailsViewController
            
            if self.isMyFood {
                view.isFromRecent = false
            }
            else {
                view.isFromRecent = true
                view.consumedObject = self.todayConsumedDataArray[indexPath.row]
            }
            view.foodObject = self.dataArray[indexPath.row]
            view.selectedMeal = self.selectedMeal
            view.selectedMealString = self.selectedMealString
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete".toLocalize()) { (action, indexPath1) in
            
            let actionsheet = UIAlertController(title: "Are_you_sure_you_want_to_delete_selected_food".toLocalize(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
            actionsheet.addAction(UIAlertAction(title: "Delete".toLocalize(), style: UIAlertAction.Style.destructive, handler: { (action) in
                
                if self.isMyFood {
                    FoodClass.deleteRecord(self.dataArray[indexPath.row])
                }
                else {
                    ConsumeClass.deleteRecord(self.todayConsumedDataArray[indexPath.row])
                }
                self.updateConsumedData()
            }))
            actionsheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
                
            }))
            self.present(actionsheet, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}
extension FoodListViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
            let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodSearchViewController") as! FoodSearchViewController
            view.foodArray = self.foodArray
            view.selectedMealString = self.selectedMealString
            view.selectedMeal = self.selectedMeal
            view.selectedDate = self.selectedDate
            let navController = UINavigationController(rootViewController: view)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: false, completion: nil)
        }
        return false
    }
}
