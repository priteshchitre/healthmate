//
//  WaterTrackViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 6/11/20.
//

import UIKit
import BAFluidView

class WaterTrackViewController: UIViewController {

    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var dropLabel: UILabel!
    @IBOutlet weak var dropImageView: UIImageView!
    @IBOutlet weak var cupView: UIView!
    @IBOutlet weak var cupImageView: UIImageView!
    @IBOutlet weak var cupLabel: UILabel!
    @IBOutlet weak var glassView: UIView!
    @IBOutlet weak var glassImageView: UIImageView!
    @IBOutlet weak var glassLabel: UILabel!
    @IBOutlet weak var bottleView: UIView!
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var fluidView: BAFluidView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    var selectedIndex : Int = 0
    var selectedDate : Date = Date()
    var progressMeter: BAFluidView = BAFluidView()
    var waterValue : Float = 0
    var waterObject = WaterClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    func initView()  {

        self.setNavigationBar()
        self.setBackBarButton(true)
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Track_Water".toLocalize())
        self.setCancelBarButton()
        self.setSaveBarButton()
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            self.contentViewHeight.constant = 250
            self.contentViewWidth.constant = 250
        }
        else if UIScreen.main.nativeBounds.height <= 1334 {
            self.contentViewHeight.constant = 300
            self.contentViewWidth.constant = 300
        }
        else if UIScreen.main.nativeBounds.height <= 2208 {
            self.contentViewHeight.constant = 350
            self.contentViewWidth.constant = 350
        }
        else  {
            self.contentViewHeight.constant = 380
            self.contentViewWidth.constant = 380
        }
        
        self.fluidView.maxAmplitude = 5
        self.fluidView.minAmplitude = 2
        self.fluidView.amplitudeIncrement = 1
        self.fluidView.backgroundColor = .clear
        self.fluidView.fillColor = UIColor(red: 91.0/255.0, green: 183.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.fluidView.fillAutoReverse = false
        self.fluidView.fillDuration = 0
        self.fluidView.fillRepeatCount = 0
        
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeUp))
        upGesture.direction = .up
        self.containerView.addGestureRecognizer(upGesture)

        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipeDown))
        downGesture.direction = .down
        self.containerView.addGestureRecognizer(downGesture)
        
        self.bottomView.layer.addCustomShadow()
        self.dropView.layer.cornerRadius = self.dropView.frame.size.height / 2
        self.cupView.layer.cornerRadius = self.cupView.frame.size.height / 2
        self.glassView.layer.cornerRadius = self.glassView.frame.size.height / 2
        self.bottleView.layer.cornerRadius = self.bottleView.frame.size.height / 2
        
        self.dropView.layer.borderWidth = 1
        self.cupView.layer.borderWidth = 1
        self.glassView.layer.borderWidth = 1
        self.bottleView.layer.borderWidth = 1
        
        self.waterValue = self.waterObject.waterValue
        self.updateBottomView()
        self.updateTopLabel()
        
        if UserClass.getSettingWater() == "ml" {
            self.dropLabel.text = "29 ml"
            self.cupLabel.text = "236 ml"
            self.glassLabel.text = "354 ml"
            self.bottleLabel.text = "709 ml"
        }
        else {
            self.dropLabel.text = "1 oz"
            self.cupLabel.text = "8 oz"
            self.glassLabel.text = "12 oz"
            self.bottleLabel.text = "24 oz"
        }

    }
    
    func setSaveBarButton() {
        
        let backButton : UIButton = UIButton()
        backButton.setTitle("Save".toLocalize(), for: UIControl.State.normal)
        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onSaveButtonTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onSaveButtonTap() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        self.waterObject.date = formatter.string(from: self.selectedDate)
        self.waterObject.waterValue = self.waterValue
        WaterClass.updateRecord(self.waterObject)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateTopLabel() {
        
        var glasses = Int(floorf(self.waterValue / 8))
        if glasses == 0  {
            if self.waterValue > 0 {
                glasses = 1
            }
        }
        var newVal = self.waterValue
        var unit = UserClass.getSettingWater()
        if UserClass.getSettingWater() == "ml" {
            newVal = (self.waterValue * 29.574) / 1000
            unit = "l"
        }

        let str1 = "\(newVal.toString()) \(unit)"
        self.topLabel.text = "\(glasses) \("glasses".toLocalize())\n\(str1)"

        let attr1 = NSMutableAttributedString(string: self.topLabel.text!)
        let matchRange1 = (self.topLabel.text! as NSString).range(of: str1)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.customFont(name: Font.RobotoMedium, size: 16) , range: matchRange1)
        
        self.topLabel.attributedText = attr1
        
        var fillTo = self.waterValue / 100.0
        if fillTo > 1 {
            fillTo = 1
        }
        
        self.fluidView.fill(to: NSNumber(value: fillTo))
    }
    
    @objc func onSwipeUp() {
        
        if self.selectedIndex == 0 {
            self.waterValue = self.waterValue + 1
        }
        else if self.selectedIndex == 1 {
            self.waterValue = self.waterValue + 8
        }
        else if self.selectedIndex == 2 {
            self.waterValue = self.waterValue + 12
        }
        else if self.selectedIndex == 3 {
            self.waterValue = self.waterValue + 24
        }
        self.updateTopLabel()
    }

    @objc func onSwipeDown() {
        
        if self.selectedIndex == 0 {
            self.waterValue = self.waterValue - 1
        }
        else if self.selectedIndex == 1 {
            self.waterValue = self.waterValue - 8
        }
        else if self.selectedIndex == 2 {
            self.waterValue = self.waterValue - 12
        }
        else if self.selectedIndex == 3 {
            self.waterValue = self.waterValue - 24
        }
        if self.waterValue <= 0 {
            self.waterValue = 0
        }
        
        self.updateTopLabel()
    }
    
    func updateBottomView() {
        
        self.dropView.layer.borderColor = Color.appOrange.cgColor
        self.cupView.layer.borderColor = Color.appOrange.cgColor
        self.glassView.layer.borderColor = Color.appOrange.cgColor
        self.bottleView.layer.borderColor = Color.appOrange.cgColor
        
        self.dropView.backgroundColor = UIColor.white
        self.cupView.backgroundColor = UIColor.white
        self.glassView.backgroundColor = UIColor.white
        self.bottleView.backgroundColor = UIColor.white
        
        if self.selectedIndex == 0 {
            self.dropView.backgroundColor = Color.appOrange
        }
        else if self.selectedIndex == 1 {
            self.cupView.backgroundColor = Color.appOrange
        }
        else if self.selectedIndex == 2 {
            self.glassView.backgroundColor = Color.appOrange
        }
        else if self.selectedIndex == 3 {
            self.bottleView.backgroundColor = Color.appOrange
        }
    }
    
    @IBAction func onDropButtonTap(_ sender: Any) {
        
        self.selectedIndex = 0
        self.updateBottomView()
    }
    
    @IBAction func onCupButtonTap(_ sender: Any) {

        self.selectedIndex = 1
        self.updateBottomView()
    }
    
    @IBAction func onGlassButtonTap(_ sender: Any) {

        self.selectedIndex = 2
        self.updateBottomView()
    }
    
    @IBAction func onBottleButtonTap(_ sender: Any) {
        
        self.selectedIndex = 3
        self.updateBottomView()
    }
}
