//
//  CreateProfileViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var comImageView1: UIImageView!
    @IBOutlet weak var comImageView2: UIImageView!
    @IBOutlet weak var comImageView3: UIImageView!
    @IBOutlet weak var comImageView4: UIImageView!
    @IBOutlet weak var comLabel1: UILabel!
    @IBOutlet weak var comLabel2: UILabel!
    @IBOutlet weak var comLabel3: UILabel!
    @IBOutlet weak var comLabel4: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var progressView: CircularProgressView!
    var percentage : Int = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.titleLabel.text = "Creating_your_profile".toLocalize()
        self.comLabel1.text = "Analyzing_your_current_weight_and_height".toLocalize()
        self.comLabel2.text = "Customizing_your_workouts".toLocalize()
        self.comLabel3.text = "Building_your_meal_plan".toLocalize()
        self.comLabel4.text = "Preparing_your_health_report".toLocalize()
        
        self.setNavigationBar()
        self.setBackBarButton(true)
        
        self.comLabel1.textColor = UIColor.black
        self.comLabel2.textColor = UIColor(red: 56, green: 57, blue: 57)
        self.comLabel3.textColor = UIColor(red: 56, green: 57, blue: 57)
        self.comLabel4.textColor = UIColor(red: 56, green: 57, blue: 57)
        
        self.comImageView1.image = UIImage(named: "check")?.image(withTintColor: Color.appOrange)
        self.comImageView2.image = UIImage(named: "uncheck")?.image(withTintColor: UIColor(red: 56, green: 57, blue: 57))
        self.comImageView3.image = UIImage(named: "uncheck")?.image(withTintColor: UIColor(red: 56, green: 57, blue: 57))
        self.comImageView4.image = UIImage(named: "uncheck")?.image(withTintColor: UIColor(red: 56, green: 57, blue: 57))
        
        self.progressView.setProgressWithAnimation(duration: 4, value: 1)
        self.progressView.trackClr = UIColor.black
        self.progressView.progressClr = Color.appOrange
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
    }
    
    func initElements() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            
            self.timer.invalidate()
            let view = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @objc func countDown() {
        
        
        if self.percentage >= 100 {
            self.timer.invalidate()
        }
        else {
            self.percentage += 1
            self.percentageLabel.text = "\(self.percentage)%"
        }
        if self.percentage >= 25 {
            self.comLabel2.textColor = UIColor.black
            self.comImageView2.image = UIImage(named: "check")?.image(withTintColor: Color.appOrange)
        }
        if self.percentage >= 50 {
            self.comLabel3.textColor = UIColor.black
            self.comImageView3.image = UIImage(named: "check")?.image(withTintColor: Color.appOrange)
        }
        if self.percentage >= 75 {
            self.comLabel4.textColor = UIColor.black
            self.comImageView4.image = UIImage(named: "check")?.image(withTintColor: Color.appOrange)
        }
    }
}
