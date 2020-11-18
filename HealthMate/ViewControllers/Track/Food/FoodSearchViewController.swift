//
//  FoodSearchViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 10/11/20.
//

import UIKit

class FoodSearchViewController: UIViewController {
    
    var searchBar: UISearchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    var foodArray : [FoodClass] = []
    var dataArray : [FoodClass] = []
    var selectedMealString = ""
    var selectedMeal : Int = 0
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
        self.searchBar.placeholder = "What_did_you_eat_today".toLocalize()
        self.searchBar.delegate = self
        self.searchBar.tintColor = Color.appOrange
        self.searchBar.showsCancelButton = true
        
        self.navigationItem.titleView = self.searchBar

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.updateSearchRecord("")
        self.searchBar.becomeFirstResponder()
    }
    
    func initElements() {
        
    }
    
    func updateSearchRecord(_ searchText : String)  {
        
        self.dataArray = self.foodArray
        if searchText != "" {
            
            let filter1 = self.dataArray.filter { (obj) -> Bool in
                return obj.foodName.lowercased().contains(searchText.lowercased())
            }
            self.dataArray = filter1
        }
        
        self.tableView.reloadData()
        
    }
}
extension FoodSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
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
            cell.titleLabel.text = object.foodName
            cell.sizeLabel.text = "\("Serving_Size".toLocalize()) : \(object.servingType)"
            cell.caloriesLabel.text = "\("Calories_per_serving".toLocalize()) : \(object.calorie.toString())"
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! FoodListCell
        cell.bgView.layer.addCustomShadow()
        cell.noDataLabel.text = "No_result_found".toLocalize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodDetailsViewController") as! FoodDetailsViewController
            view.isFromRecent = false
            view.foodObject = self.dataArray[indexPath.row]
            view.selectedMeal = self.selectedMeal
            view.selectedMealString = self.selectedMealString
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
extension FoodSearchViewController : UISearchBarDelegate {
    
    
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
