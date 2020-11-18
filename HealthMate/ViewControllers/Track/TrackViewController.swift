//
//  TrackViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit

class TrackViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var consumedDataArray : [ConsumeClass] = []
    var dataArray : [ConsumeClass] = []

    var burnedDataArray : [BurnedClass] = []
    var selectedBurnedDataArray : [BurnedClass] = []

    var waterDataArray : [WaterClass] = []
    var selectedWaterObject = WaterClass()

    var weightDataArray : [WeightClass] = []
    var selectedWeightObject = WeightClass()
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_TRACK_VIEW), object: nil)
        self.initView()
        self.initElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateConsumedData()
    }
    
    @objc func initLocal() {
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setMenuBarButton()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: Constants.APP_TITLE)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    @objc func updateConsumedData() {

        self.weightDataArray = WeightClass.getweightArray()
        self.waterDataArray = WaterClass.getWaterArray()
        self.consumedDataArray = ConsumeClass.getConsumeArray()
        self.burnedDataArray = BurnedClass.getBurnedArray()
        self.updateConsumeObject()
    }
    
    func updateConsumeObject() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        let dateString = formatter.string(from: self.selectedDate)
        let filterArray = self.consumedDataArray.filter { (obj) -> Bool in
            return dateString == obj.date
        }
        self.dataArray = filterArray
        
        let filterArray1 = self.burnedDataArray.filter { (obj) -> Bool in
            return dateString == obj.date
        }
        self.selectedBurnedDataArray = filterArray1
        
        //Water Data
        
        let waterFilter = self.waterDataArray.filter { (obj) -> Bool in
            return obj.date == dateString
        }
        if waterFilter.count > 0 {
            self.selectedWaterObject = waterFilter[0]
        }
        else {
            self.selectedWaterObject = WaterClass()
        }
        
        //Weight Data
        
        let weightFilter = self.weightDataArray.filter { (obj) -> Bool in
            return obj.date == dateString
        }
        if weightFilter.count > 0 {
            self.selectedWeightObject = weightFilter[0]
        }
        else {
            self.selectedWeightObject = WeightClass()
        }
        self.tableView.reloadData()
    }
    
    @objc func onNextButtonTap() {
        
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate) ?? Date()
        self.updateConsumeObject()
    }
    
    @objc func onPreviousButtonTap() {

        self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate) ?? Date()
        self.updateConsumeObject()
    }
    
    @objc func onBreakfastButtonTap() {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        view.selectedMeal = 0
        view.selectedMealString = "Breakfast".toLocalize()
        view.selectedDate = self.selectedDate
        self.navigationController?.pushViewController(view, animated: true)
    }

    @objc func onLunchButtonTap() {

        let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        view.selectedMeal = 1
        view.selectedMealString = "Lunch".toLocalize()
        view.selectedDate = self.selectedDate
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func onDinnerButtonTap() {

        let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        view.selectedMeal = 2
        view.selectedMealString = "Dinner".toLocalize()
        view.selectedDate = self.selectedDate
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func onSnackButtonTap() {

        let view = self.storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        view.selectedMeal = 3
        view.selectedMealString = "Snack".toLocalize()
        view.selectedDate = self.selectedDate
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func onExerciseButtonTap() {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesViewController") as! ExerciseCaloriesViewController
        view.selectedDate = self.selectedDate
        let navController = UINavigationController(rootViewController: view)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func onWaterButtonTap() {

        let view = self.storyboard?.instantiateViewController(withIdentifier: "WaterTrackViewController") as! WaterTrackViewController
        view.selectedDate = self.selectedDate
        if self.selectedWaterObject.date == "" {
            let obj = WaterClass()
            let timestamp = NSDate().timeIntervalSince1970
            obj.waterId = "\(timestamp)"
            view.waterObject = obj
        }
        else {
            view.waterObject = self.selectedWaterObject
        }
        let navController = UINavigationController(rootViewController: view)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func onBottomWeightButtonTap() {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WeightTrackViewController") as! WeightTrackViewController
        view.selectedDate = self.selectedDate
        if self.selectedWeightObject.date == "" {
            let obj = WeightClass()
            let timestamp = NSDate().timeIntervalSince1970
            obj.weightId = "\(timestamp)"
            view.weightObject = obj
        }
        else {
            view.weightObject = self.selectedWeightObject
        }
        let navController = UINavigationController(rootViewController: view)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}
extension TrackViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            if self.selectedWeightObject.weight > 0 {
                return 1
            }
            else {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TrackCell
            cell.titleLabel.text = "Today".toLocalize()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            let today = formatter.string(from: Date())
            let selectedDate = formatter.string(from: self.selectedDate)
            if today == selectedDate {
                cell.titleLabel.text = "Today".toLocalize()
            }
            else {
                formatter.dateFormat = "MMM dd, yyyy"
                cell.titleLabel.text = formatter.string(from: self.selectedDate)
            }
            cell.previousButton.setImage(UIImage(named: "Arrow_back_health")?.image(withTintColor: UIColor.black), for: UIControl.State.normal)
            cell.nextButton.setImage(UIImage(named: "Arrow_front")?.image(withTintColor: UIColor.black), for: UIControl.State.normal)
            cell.nextButton.addTarget(self, action: #selector(self.onNextButtonTap), for: UIControl.Event.touchUpInside)
            cell.previousButton.addTarget(self, action: #selector(self.onPreviousButtonTap), for: UIControl.Event.touchUpInside)
            return cell
        }
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath) as! TrackCell
            cell.caloriesView.layer.addCustomShadow()
            
            
            cell.consumedTextLabel.text = "Consumed".toLocalize()
            cell.burnTextLabel.text = "Burned".toLocalize()
            cell.netTextLabel.text = "Net".toLocalize()

             let val = self.dataArray.map { obj in
                obj.servings * obj.foodObject.calorie
            }
            let consumedCaloriesSum = val.reduce(0, +)
            cell.consumedCountLabel.text = consumedCaloriesSum.toString()
            
            
            let burnedVal = self.selectedBurnedDataArray.map { obj in
               obj.calories
           }
            
            let burnCalories : Float = burnedVal.reduce(0, +)
            let netCalories = consumedCaloriesSum - burnCalories
            cell.netCountLabel.text = netCalories.toString()
            cell.burnCountLabel.text = burnCalories.toString()
            
            let calories = UserClass.getGoalCalories() - netCalories
            cell.caloriesLeftLabel.text = "\(calories.toString()) \("Calories_left".toLocalize())"
            return cell
        }
        if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath) as! TrackCell
            cell.weightView.layer.addCustomShadow()
            cell.weightTextLabel.text = "Weight".toLocalize()
            
            var weight = self.selectedWeightObject.weight
            
            if self.selectedWeightObject.measurement.lowercased() == "kg" {
                
                if UserClass.getSettingWeight().lowercased() == "kg" {
                    weight = self.selectedWeightObject.weight
                }
                else {
                    weight = self.selectedWeightObject.weight * 2.205
                }
            }
            else {
                
                if UserClass.getSettingWeight().lowercased() == "kg" {
                    weight = self.selectedWeightObject.weight / 2.205
                }
                else {
                    weight = self.selectedWeightObject.weight
                }
            }
            cell.weightCountLabel.text = "\(weight.toString()) \(UserClass.getSettingWeight())"
            return cell
        }
        if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! TrackCell
            cell.breackfastView.layer.addCustomShadow()
            cell.lunchView.layer.addCustomShadow()
            cell.dinnerView.layer.addCustomShadow()
            cell.snackView.layer.addCustomShadow()
            
            cell.breakfastButton.addTarget(self, action: #selector(self.onBreakfastButtonTap), for: UIControl.Event.touchUpInside)
            cell.lunchButton.addTarget(self, action: #selector(self.onLunchButtonTap), for: UIControl.Event.touchUpInside)
            cell.dinnerButton.addTarget(self, action: #selector(self.onDinnerButtonTap), for: UIControl.Event.touchUpInside)
            cell.snakeButton.addTarget(self, action: #selector(self.onSnackButtonTap), for: UIControl.Event.touchUpInside)
            
            cell.breakfastTextLabel.text = "Breakfast".toLocalize()
            cell.lunchTextLabel.text = "Lunch".toLocalize()
            cell.dinnerTextLabel.text = "Dinner".toLocalize()
            cell.snackLabel.text = "Snack".toLocalize()
            
            //Breakfast
            let array1 = self.dataArray.filter { (obj) -> Bool in
                return obj.mealType == 0
            }
            if array1.count > 0 {
                cell.breackfastImageView.image = UIImage(named: "Breakfast")
            }
            else {
                cell.breackfastImageView.image = UIImage(named: "Breakfast_inactive")
            }
            //Lunch
            let array2 = self.dataArray.filter { (obj) -> Bool in
                return obj.mealType == 1
            }
            if array2.count > 0 {
                cell.lunchImageView.image = UIImage(named: "Lunch")
            }
            else {
                cell.lunchImageView.image = UIImage(named: "Lunch_inactive")
            }
            //Dinner
            let array3 = self.dataArray.filter { (obj) -> Bool in
                return obj.mealType == 2
            }
            if array3.count > 0 {
                cell.dinnerImageView.image = UIImage(named: "Dinner")
            }
            else {
                cell.dinnerImageView.image = UIImage(named: "Dinner_inactive")
            }
            
            //Snack
            let array4 = self.dataArray.filter { (obj) -> Bool in
                return obj.mealType == 3
            }
            if array4.count > 0 {
                cell.snackImageView.image = UIImage(named: "Snack")
            }
            else {
                cell.snackImageView.image = UIImage(named: "Snack_inactive")
            }
            
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BottomCell", for: indexPath) as! TrackCell
        
        let width = (UIScreen.main.bounds.size.width - 80) / 3
        
        cell.exerciseViewHeight.constant = width
        cell.exerciseViewWidth.constant = width

        cell.bottomWeightViewWidth.constant = width
        cell.bottomWeightViewHeight.constant = width

        cell.waterViewWidth.constant = width
        cell.waterViewHeight.constant = width
        
        cell.exerciseView.layoutIfNeeded()
        cell.bottomWeightView.layoutIfNeeded()
        cell.waterView.layoutIfNeeded()
        
        cell.exerciseView.layer.addCustomShadow()
        cell.bottomWeightView.layer.addCustomShadow()
        cell.waterView.layer.addCustomShadow()
        cell.exerciseView.layer.cornerRadius = cell.exerciseView.frame.size.height / 2
        cell.bottomWeightView.layer.cornerRadius = cell.exerciseView.frame.size.height / 2
        cell.waterView.layer.cornerRadius = cell.exerciseView.frame.size.height / 2
        
        cell.exerciseLabel.text = "Exercise".toLocalize()
        cell.bottomWeightTextLabel.text = "Weight".toLocalize()
        cell.waterLabel.text = "Water".toLocalize()
        
        cell.exerciseButton.addTarget(self, action: #selector(self.onExerciseButtonTap), for: UIControl.Event.touchUpInside)
        cell.bottomWeightButton.addTarget(self, action: #selector(self.onBottomWeightButtonTap), for: UIControl.Event.touchUpInside)
        cell.waterButton.addTarget(self, action: #selector(self.onWaterButtonTap), for: UIControl.Event.touchUpInside)
        
        cell.bottomWeightImageView.image = UIImage(named: "Weight_inactive")
        if self.selectedWeightObject.weight > 0 {
            
            var weight = self.selectedWeightObject.weight
            
            if self.selectedWeightObject.measurement.lowercased() == "kg" {
                
                if UserClass.getSettingWeight().lowercased() == "kg" {
                    weight = self.selectedWeightObject.weight
                }
                else {
                    weight = self.selectedWeightObject.weight * 2.205
                }
            }
            else {
                
                if UserClass.getSettingWeight().lowercased() == "kg" {
                    weight = self.selectedWeightObject.weight / 2.205
                }
                else {
                    weight = self.selectedWeightObject.weight
                }
            }
            
            cell.bottomWeightLabel.text = "\(weight.toString()) \(UserClass.getSettingWeight())"
            cell.bottomWeightLabel.isHidden = false
            cell.bottomWeightImageView.isHidden = true
        }
        else {
            cell.bottomWeightLabel.text = ""
            cell.bottomWeightLabel.isHidden = true
            cell.bottomWeightImageView.isHidden = false
        }
        if self.selectedWaterObject.waterValue > 0 {
            cell.waterImageView.image = UIImage(named: "Water")
        }
        else {
            cell.waterImageView.image = UIImage(named: "Water_inactive")
        }
        if self.selectedBurnedDataArray.count > 0 {
            cell.exerciseImageView.image = UIImage(named: "Exercise_active")
        }
        else {
            cell.exerciseImageView.image = UIImage(named: "Exercise_inactive")
        }

        return cell
    }
}
extension TrackViewController : UITextFieldDelegate {
    
}
