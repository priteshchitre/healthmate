//
//  ExerciseCaloriesViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit

class ExerciseCaloriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissView), name: NSNotification.Name("DismissExerciseView"), object: nil)
        self.initView()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setBackBarButton(true)
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Exercise".toLocalize())
        self.setCancelBarButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func dismissView() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
extension ExerciseCaloriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            let searchBar = cell.viewWithTag(101) as! UISearchBar
            searchBar.delegate = self
            searchBar.placeholder = "Search_Exercises".toLocalize()
            return cell
        }
        if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let titleLabel = cell.viewWithTag(101) as! UILabel
            let imageView = cell.viewWithTag(100) as! UIImageView
            let bgView = cell.viewWithTag(103)!
            bgView.layer.addCustomShadow()
            titleLabel.text = "Enter_Calories_Burned".toLocalize()
            imageView.image = UIImage(named: "Exercise_inactive")?.image(withTintColor: UIColor.black)
            return cell
        }
        if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            let titleLabel = cell.viewWithTag(101) as! UILabel
            titleLabel.text = "MY_EXERCISES".toLocalize()
            return cell
        }
        if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let titleLabel = cell.viewWithTag(101) as! UILabel
            let imageView = cell.viewWithTag(100) as! UIImageView
            let bgView = cell.viewWithTag(103)!
            bgView.layer.addCustomShadow()
            titleLabel.text = "Recently_Performed".toLocalize()
            imageView.image = UIImage(named: "recent")?.image(withTintColor: UIColor.black)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let titleLabel = cell.viewWithTag(101) as! UILabel
        let imageView = cell.viewWithTag(100) as! UIImageView
        let bgView = cell.viewWithTag(103)!
        bgView.layer.addCustomShadow()
        titleLabel.text = "Custom_Exercises".toLocalize()
        imageView.image = UIImage(named: "Exercise_inactive")?.image(withTintColor: UIColor.black)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "CaloriesBurnedViewController") as! CaloriesBurnedViewController
            let obj = ExerciseClass()
            let timestamp = NSDate().timeIntervalSince1970
            obj.exerciseId = "\(timestamp)"
            view.exerciseObject = obj
            view.isAdd = true
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
        else if indexPath.row == 3 {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesListViewController") as! ExerciseCaloriesListViewController
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
        else if indexPath.row == 4 {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "CustomExerciseViewController") as! CustomExerciseViewController
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
extension ExerciseCaloriesViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            let view = self.storyboard?.instantiateViewController(withIdentifier: "SearchExerciseViewController") as! SearchExerciseViewController
            view.selectedDate = self.selectedDate
            let navController = UINavigationController(rootViewController: view)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: false, completion: nil)
        }
        return false
    }
}
