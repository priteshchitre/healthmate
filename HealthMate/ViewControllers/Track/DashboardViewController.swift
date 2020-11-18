//
//  DashboardViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 27/10/20.
//

import UIKit

class DashboardViewController: UITabBarController {

    var trackItem = UITabBarItem()
    var progressItem = UITabBarItem()
    var recipeItem = UITabBarItem()
    var workoutsItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserClass.setIsLogin(true)
        self.initView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_DASHBOARD), object: nil)
        
        if let dataDic = Global.getFileDetails("calorieCalculator") {
            if let array = dataDic.value(forKey: "data") as? NSArray {
                Global.sharedInstance.calorieCalculatorArray = CalorieCalculatorClass.initWithArray(array)
            }
        }
    }
    
    @objc func initLocal() {

        self.trackItem.title = "Track".toLocalize()
        self.progressItem.title = "Progress".toLocalize()
        self.recipeItem.title = "Recipe".toLocalize()
        self.workoutsItem.title = "Workouts".toLocalize()
    }
    
    func initView() {
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = Color.appOrange
        self.tabBar.backgroundColor = UIColor.white
        
        self.tabBar.layer.masksToBounds = false
        self.tabBar.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
        self.tabBar.layer.shadowOpacity = 0.4
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.tabBar.layer.shadowRadius = 2
        
        let trackView = self.storyboard?.instantiateViewController(withIdentifier: "TrackViewController") as! TrackViewController
        self.trackItem = UITabBarItem(title: "Track".toLocalize(), image: UIImage(named: "track"), tag: 0)
        trackView.tabBarItem = self.trackItem
        let trackNavController = UINavigationController(rootViewController: trackView)

        let progressView = self.storyboard?.instantiateViewController(withIdentifier: "ProgressViewController") as! ProgressViewController
        self.progressItem = UITabBarItem(title: "Progress".toLocalize(), image: UIImage(named: "Progress"), tag: 1)
        progressView.tabBarItem = self.progressItem
        let progressNavController = UINavigationController(rootViewController: progressView)
        
        let recipeView = self.storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as! RecipeViewController
        self.recipeItem = UITabBarItem(title: "Recipe".toLocalize(), image: UIImage(named: "Recipes"), tag: 2)
        recipeView.tabBarItem = self.recipeItem
        let recipeNavController = UINavigationController(rootViewController: recipeView)
        
        let workoutsView = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutsViewController") as! WorkoutsViewController
        self.workoutsItem = UITabBarItem(title: "Workouts".toLocalize(), image: UIImage(named: "Workouts"), tag: 3)
        workoutsView.tabBarItem = self.workoutsItem
        let workoutsNavController = UINavigationController(rootViewController: workoutsView)
        
        self.setViewControllers([trackNavController, progressNavController, recipeNavController, workoutsNavController], animated: true)
    }
}
