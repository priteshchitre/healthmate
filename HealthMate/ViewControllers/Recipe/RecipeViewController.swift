//
//  RecipeViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit
import SDWebImage
import ActionSheetPicker_3_0

class RecipeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    var dataArray : [RecipeClass] = []
    var mainDataArray : [RecipeClass] = []
    var selectedDiet : String = ""
    var filterValue = RECIPE_MEALS.BREAKFAST.rawValue
    var isLoading : Bool = false
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_RECIPE), object: nil)
    }
    
    @objc func initLocal() {
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Recipes".toLocalize())
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setMenuBarButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.selectedDiet = RECIPE_DIETS.OMNIVORE.rawValue
        self.getRecipes()
    }
    
    func initElements() {
        
    }
    
    @objc func pullToRefresh() {
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        self.getRecipes()
    }
    
    func getRecipes() {
        
        if !Global.checkNetworkConnectivity() {
            self.getLocalRecipe()
            return
        }
        
        let param : NSMutableDictionary = NSMutableDictionary()
        
        Global.showProgressHud()
        
        self.isLoading = true
        APIHelperClass.sharedInstance.getRequest("\(APIHelperClass.recipes)/\(self.selectedDiet)", parameters: param) { (result, error, statusCode) in

            self.isLoading = false
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    Global.createJSONDetails("Recipes", jsonData: dataDic)
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        self.mainDataArray = RecipeClass.initWithArray(dataArray)
                        self.filterRecord()
                        return
                    }
                }
            }
        }
    }
    
    func getLocalRecipe() {
        
        if let dataDic = Global.getFileDetails("Recipes") {
            if let array = dataDic.value(forKey: "data") as? NSArray {
                self.mainDataArray = RecipeClass.initWithArray(array)
                self.filterRecord()
            }
        }
    }
    
    func filterRecord() {
        
        self.dataArray = self.mainDataArray.filter({ (obj) -> Bool in
            return obj.meals.contains(self.filterValue)
        })
        self.tableView.reloadData()
    }
    
    @objc func onBreakfastButtonTap(_ sender : UIButton) {
        
        self.filterValue = RECIPE_MEALS.BREAKFAST.rawValue
        self.filterRecord()
    }
    
    @objc func onLunchButtonTap(_ sender : UIButton) {
        
        self.filterValue = RECIPE_MEALS.LUNCH_DINNER.rawValue
        self.filterRecord()
    }
    
    @objc func onSnackButtonTap(_ sender : UIButton) {
        
        self.filterValue = RECIPE_MEALS.SNACK.rawValue
        self.filterRecord()
    }
}
extension RecipeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            if self.isLoading {
                return 0
            }
            return self.dataArray.count == 0 ? 1 : 0
        }
        if section == 3 {
            return self.dataArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! RecipeListCell
            cell.titleLabel.text = "Looking_for_healthy_Recipes".toLocalize()
            cell.subTitleLabel.text = "Simple_healthy_meal_designed_especially_for_you".toLocalize()
            return cell
        }
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! RecipeListCell
            cell.breakfastButton.layer.cornerRadius = 5
            cell.lunchButton.layer.cornerRadius = 5
            cell.snackButton.layer.cornerRadius = 5
            
            cell.titleLabel.text = "Meal".toLocalize()
            cell.breakfastButton.setTitle("Breakfast".toLocalize(), for: UIControl.State.normal)
            cell.lunchButton.setTitle("\("Lunch".toLocalize())/\("Dinner".toLocalize())", for: UIControl.State.normal)
            cell.snackButton.setTitle("Snack".toLocalize(), for: UIControl.State.normal)
            
            cell.breakfastButton.addTarget(self, action: #selector(self.onBreakfastButtonTap(_:)), for: .touchUpInside)
            cell.lunchButton.addTarget(self, action: #selector(self.onLunchButtonTap(_:)), for: .touchUpInside)
            cell.snackButton.addTarget(self, action: #selector(self.onSnackButtonTap(_:)), for: .touchUpInside)
            
            cell.breakfastButton.backgroundColor = Color.appGray
            cell.lunchButton.backgroundColor = Color.appGray
            cell.snackButton.backgroundColor = Color.appGray
            if self.filterValue == RECIPE_MEALS.BREAKFAST.rawValue {
                cell.breakfastButton.backgroundColor = Color.appOrange
            }
            else if self.filterValue == RECIPE_MEALS.LUNCH_DINNER.rawValue {
                cell.lunchButton.backgroundColor = Color.appOrange
            }
            else {
                cell.snackButton.backgroundColor = Color.appOrange
            }

            return cell
        }
        if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PreferenceCell", for: indexPath) as! RecipeListCell
            var diet = ""
            if self.selectedDiet == RECIPE_DIETS.OMNIVORE.rawValue {
                diet = "\("Omnivore".toLocalize())"
            }
            else if self.selectedDiet == RECIPE_DIETS.PESCATARIAN.rawValue {
                diet = "\("Pescatarian".toLocalize())"
            }
            else if self.selectedDiet == RECIPE_DIETS.VEGETARIAN.rawValue {
                diet = "\("Vegetarian".toLocalize())"
            }
            else {
                diet = "\("Vegan".toLocalize())"
            }
            cell.preferencesLabel.text = "\("Dietary_Preference".toLocalize()): \(diet)"
            return cell
        }
        if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeListCell
            let object = self.dataArray[indexPath.row]
            cell.recipeTitleLabel.text = object.title
            cell.recipeImageView.sd_setImage(with: URL(string: object.image), placeholderImage: UIImage(named: "recipePlaceholder"), options: SDWebImageOptions.continueInBackground, context: nil)
            cell.seringLabel.text = "\(object.calorie.toString()) cal/\("servings".toLocalize()), \("serve".toLocalize()) \(object.serve)"
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath) as! RecipeListCell
        cell.bgView.layer.addCustomShadow()
        cell.noDataLabel.text = "No_Recipe_Found".toLocalize()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let array = ["Omnivore".toLocalize(),"Pescatarian".toLocalize(),"Vegetarian".toLocalize(),"Vegan".toLocalize()]
            
            let picker = ActionSheetStringPicker(title: "Dietary_Preference".toLocalize(), rows: array, initialSelection: self.selectedIndex, doneBlock: { (picker, index, value) in
                
                self.selectedIndex = index
                if index == 0 {
                    self.selectedDiet = RECIPE_DIETS.OMNIVORE.rawValue
                }
                else if index == 1 {
                    self.selectedDiet = RECIPE_DIETS.PESCATARIAN.rawValue
                }
                else if index == 2 {
                    self.selectedDiet = RECIPE_DIETS.VEGETARIAN.rawValue
                }
                else {
                    self.selectedDiet = RECIPE_DIETS.VEGAN.rawValue
                }
                self.getRecipes()
            }, cancel: { (picker) in
                
            }, origin: self.view)
            picker?.show()
        }
        if indexPath.section == 3 {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
            view.object = self.dataArray[indexPath.row]
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
