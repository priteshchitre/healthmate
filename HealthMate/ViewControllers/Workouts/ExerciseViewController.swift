//
//  ExerciseViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import AVFoundation

class ExerciseViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    var object = WorkoutExerciseClass()
    var player : AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_EXCERCISE), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        if self.player != nil {
            self.player.pause()
            self.player = nil
        }
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: self.object.title)
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        
    }
    
    func initElements() {
        
        if let videoURL = self.object.filePathURL {

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
            self.player.play()
            
        }
    }
}
