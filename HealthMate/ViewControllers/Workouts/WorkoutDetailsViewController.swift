//
//  WorkoutDetailsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import SDWebImage

class WorkoutDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var object = WorkoutClass()
    var isDownloadFinished : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_WORKOUT_DETAILS), object: nil)
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Workout_Details".toLocalize())
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
        self.downloadVideo()
    }
    
    @objc func onStartButtonTap()  {
        
        if self.isDownloadFinished {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "StartWorkoutViewController") as! StartWorkoutViewController
            view.object = self.object
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func downloadVideo() {
        
        let group = DispatchGroup()
        
        for obj in self.object.workoutExerciseArray {
            
            group.enter()
            CacheManager.shared.getFileWith(stringUrl: obj.videoURL) { (result) in
                
                switch result {
                case .success(let url):
                    print("url = ", url)
                    obj.filePathURL = url
                    obj.isDownloaded = true
                    self.tableView.reloadData()
                    break
                case .failure( _):
                    break
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            
            self.isDownloadFinished = true
            self.tableView.reloadData()
        }
    }
}
extension WorkoutDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return self.object.workoutExerciseArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkoutCell
            cell.bgView.layer.addCustomShadow()
            cell.statusLabel.layer.cornerRadius = 3
            cell.titleLabel.text = self.object.title
            cell.statusLabel.text = self.object.difficulty
            cell.subLabel.text = "\("Level".toLocalize()): \(self.object.level)"
            cell.workoutImageView.sd_setImage(with: URL(string: self.object.image)!, placeholderImage: UIImage(named: "start workout"), options: SDWebImageOptions.continueInBackground, context: nil)
            return cell
        }
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "StartCell", for: indexPath) as! WorkoutCell
            cell.startButton.layer.cornerRadius = 5
            cell.startButton.addTarget(self, action: #selector(self.onStartButtonTap), for: UIControl.Event.touchUpInside)
            cell.startButton.setTitle("Start_Workout".toLocalize(), for: UIControl.State.normal)
            if self.isDownloadFinished {
                cell.startButton.backgroundColor = Color.appOrange
            }
            else {
                cell.startButton.backgroundColor = Color.appGray
            }
            return cell
        }
        if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! WorkoutCell
            cell.contentLabel.text = self.object.workoutDescription
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! WorkoutCell
        cell.typeView.layer.addCustomShadow()
        cell.typeLabel.text = self.object.workoutExerciseArray[indexPath.row].title
        
        cell.activityView.isHidden = self.object.workoutExerciseArray[indexPath.row].isDownloaded
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            
            if self.object.workoutExerciseArray[indexPath.row].isDownloaded {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseViewController") as! ExerciseViewController
                view.object = self.object.workoutExerciseArray[indexPath.row]
                self.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
}
