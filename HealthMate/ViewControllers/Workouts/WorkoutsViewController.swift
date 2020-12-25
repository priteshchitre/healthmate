//
//  WorkoutsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit
import SDWebImage

class WorkoutsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    var dataArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_WORKOUT), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.dataArray.count > 0 {
            Global.sharedInstance.workoutArray = WorkoutClass.initWithArray(self.dataArray)
            self.tableView.reloadData()
        }
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Workout".toLocalize())
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
        
        self.getWorkouts()
    }
    
    func initElements() {
        
    }
    
    @objc func pullToRefresh() {
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        self.getWorkouts()
    }
    
    func getWorkouts() {
        
        if !Global.checkNetworkConnectivity() {
            self.getLocalWorkouts()
            return
        }
        
        let param : NSMutableDictionary = NSMutableDictionary()
        
        Global.showProgressHud()
        
        APIHelperClass.sharedInstance.getRequest("\(APIHelperClass.workouts)", parameters: param) { (result, error, statusCode) in
            
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    Global.createJSONDetails("Workouts", jsonData: dataDic)
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        Global.sharedInstance.workoutArray = WorkoutClass.initWithArray(dataArray)
                        self.dataArray = dataArray
                        self.tableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func getLocalWorkouts() {
        
        if let dataDic = Global.getFileDetails("Workouts") {
            if let array = dataDic.value(forKey: "data") as? NSArray {
                Global.sharedInstance.workoutArray = WorkoutClass.initWithArray(array)
                self.tableView.reloadData()
            }
        }
    }
}
extension WorkoutsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.sharedInstance.workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkoutCell
        cell.bgView.layer.addCustomShadow()
        cell.statusLabel.layer.cornerRadius = 3
        let object = Global.sharedInstance.workoutArray[indexPath.row]
        
        cell.calLabel.text = "\(object.calorie.toRound()) \("cal".toLocalize())"
        cell.minLabel.text = "\(object.duration) \("min".toLocalize())"
        cell.statusLabel.text = object.difficulty.capitalized
        cell.titleLabel.text = object.title
        cell.workoutImageView.sd_setImage(with: URL(string: object.image)!, placeholderImage: UIImage(named: "start workout"), options: SDWebImageOptions.continueInBackground, context: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailsViewController") as! WorkoutDetailsViewController
        view.object = Global.sharedInstance.workoutArray[indexPath.row]
        self.navigationController?.pushViewController(view, animated: true)
    }
}
