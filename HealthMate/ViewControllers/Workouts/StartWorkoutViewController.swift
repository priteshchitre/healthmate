//
//  StartWorkoutViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import AVFoundation

class StartWorkoutViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var cancelWorkoutButton: UIButton!
    @IBOutlet weak var pauseWorkout: UIButton!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    
    var currentStep : Int = 0
    var totalStep : Int = 9
    var object = WorkoutClass()
    var player : AVPlayer!
    var isPause : Bool = false
    var timer : Timer = Timer()
    var counter : Int = 0
    var isRestTime : Bool = false
    var isPreviewTime : Bool = true
    
    let restTime : Int = 15
    let previewTime : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_SUBSCRIPTION), object: nil)
    }
    
    @objc func initLocal() {
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Start_Workout".toLocalize())
        self.cancelWorkoutButton.setTitle("Cancel_Workout".toLocalize(), for: UIControl.State.normal)
        self.pauseWorkout.setTitle("Pause_Workout".toLocalize(), for: UIControl.State.normal)
        self.restLabel.text = "Rest".toLocalize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.player != nil {
            self.timer.invalidate()
            self.player.pause()
            self.player = nil
        }
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setBack()
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            self.videoViewHeight.constant = 220
        }
        else if UIScreen.main.nativeBounds.height <= 1334 {
            self.videoViewHeight.constant = 250
        }
        else if UIScreen.main.nativeBounds.height <= 2208 {
            self.videoViewHeight.constant = 300
        }
        else  {
            self.videoViewHeight.constant = 350
        }
        
        self.pauseWorkout.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cancelWorkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.pauseWorkout.layer.cornerRadius = 5
        self.cancelWorkoutButton.layer.cornerRadius = 5
        
        self.totalStep = self.object.workoutExerciseArray.count
        
        self.stepLabel.text = "\("Step".toLocalize()) \(currentStep) \("of".toLocalize()) \(self.totalStep)"
        let attributedString: NSMutableAttributedString = self.stepLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        let longString = self.stepLabel.text! as NSString
        let matchRange = (longString as NSString).range(of: "\("of".toLocalize()) \(self.totalStep)")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.appGray , range: matchRange)
        self.stepLabel.attributedText = attributedString
    }
    
    func initElements() {
        
        self.videoView.isHidden = false
        self.restView.isHidden = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerExecution), userInfo: nil, repeats: true)
        self.timer.fire()
        self.videoPlay()
    }
    
    func setBack() {
        
        let backButton : UIButton = UIButton()
        backButton.setImage(UIImage(named: "Status-Bar-back Arrow-2"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onBackTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.imageWith(color: Color.appOrange, for: UIControl.State.normal)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func onBackTap() {
        
        self.cancelWorkout()
    }
    
    func startTimer() {
        
        self.player.play()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerExecution), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        
        self.player.pause()
        self.timer.invalidate()

    }
    
    
    @objc func timerExecution()  {
        
        if self.isPreviewTime {
            
            if self.counter > self.previewTime {
                self.counter = 0
                self.isPreviewTime = false
            }
        }
        else if self.isRestTime {
            
            if self.counter > self.restTime {
                self.counter = 0
                self.isRestTime = false
                self.isPreviewTime = true
                self.videoView.isHidden = false
                self.restView.isHidden = true
                self.currentStep = self.currentStep + 1
                
                self.videoPlay()
            }
        }
        else {
            
            if self.counter > self.object.workoutExerciseArray[self.currentStep].duration {
                self.counter = 0
                self.isRestTime = true
                self.videoView.isHidden = true
                self.restView.isHidden = false
            }
        }
        self.updateTimeLabel()
        self.counter += 1
        
    }
    
    func finishWorkout() {
        
        self.timer.invalidate()
        if self.player != nil {
            self.player.pause()
        }
        let view = self.storyboard?.instantiateViewController(withIdentifier: "FinishWorkoutViewController") as! FinishWorkoutViewController
        view.object = self.object
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func videoPlay() {
        
        if self.currentStep >= self.object.workoutExerciseArray.count {
            
            self.finishWorkout()
            return
        }
        self.updateStepLabel()
        if let videoURL = self.object.workoutExerciseArray[self.currentStep].filePathURL {

            self.player = AVPlayer(url: videoURL)
            self.player.isMuted = true
            let playerLayer = AVPlayerLayer(player: self.player)
            self.videoView.layoutIfNeeded()
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = .resizeAspect
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil) { (_) in
               
                self.player.seek(to: CMTime.zero)
                self.player.play()
            }

            self.videoView.layer.addSublayer(playerLayer)
            player.play()
        }
    }
    
    func updateTimeLabel() {
        
        var currentTimeInSeconds = Float(self.counter)
        if self.isPreviewTime {
            currentTimeInSeconds = Float(self.previewTime) - Float(self.counter)
        }
        else if self.isRestTime {
            currentTimeInSeconds = Float(self.restTime) - Float(self.counter)
        }
        else {
            currentTimeInSeconds = Float(self.object.workoutExerciseArray[self.currentStep].duration) - Float(self.counter)
        }
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        if self.isPreviewTime {
            self.timeLabel.text = "-\(minsStr):\(secsStr)"
            self.timeLabel.textColor = UIColor.red
        }
        else {
            self.timeLabel.text = "\(minsStr):\(secsStr)"
            self.timeLabel.textColor = UIColor.black
        }

    }
    
    func updateStepLabel() {
        
        self.titleLabel.text = self.object.workoutExerciseArray[self.currentStep].title
        self.stepLabel.text = "\("Step".toLocalize()) \(self.currentStep + 1) \("of".toLocalize()) \(self.totalStep)"
        let attributedString: NSMutableAttributedString = self.stepLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        let longString = self.stepLabel.text! as NSString
        let matchRange = (longString as NSString).range(of: "\("of".toLocalize()) \(self.totalStep)")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.appGray , range: matchRange)
        self.stepLabel.attributedText = attributedString
    }
    
    @IBAction func onCancelWorkoutButtonTap(_ sender: Any) {
        
        self.cancelWorkout()
    }
    
    func cancelWorkout() {
        
        self.pauseTimer()
        let alert = UIAlertController(title: "\("Cancel_Workout".toLocalize())?", message: "Do_you_want_to_leave_and_cancel_this_workout".toLocalize(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel_Workout".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Continue_Workout".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            self.startTimer()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onPauseWorkoutTap(_ sender: Any) {
        
        if self.player != nil {

            self.isPause = !self.isPause
            
            if self.isPause {
                self.pauseTimer()
                self.pauseWorkout.setTitle("Resume_Workout".toLocalize(), for: UIControl.State.normal)
            }
            else {
                self.startTimer()
                self.pauseWorkout.setTitle("Pause_Workout".toLocalize(), for: UIControl.State.normal)
            }
        }
    }
}
