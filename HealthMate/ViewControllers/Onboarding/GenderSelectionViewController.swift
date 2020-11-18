//
//  GenderSelectionViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class GenderSelectionViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var maleButton: RoundButton!
    @IBOutlet weak var femaleButton: RoundButton!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var nonButton: RoundButton!
    
    @IBOutlet weak var arrow1ImageView: UIImageView!
    @IBOutlet weak var arrow2ImageView: UIImageView!
    @IBOutlet weak var arrow3ImageView: UIImageView!
    @IBOutlet weak var logoViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {

        if UIScreen.main.nativeBounds.height <= 1136 {
            self.logoViewBottom.constant = 10
        }
        self.logoView.layoutIfNeeded()
        self.logoView.layer.cornerRadius = self.logoView.frame.size.height / 2
        self.navigationController?.isNavigationBarHidden = true
        self.topLabel.text = "What_your_Gender".toLocalize()
        self.maleButton.setTitle("    \("Male".toLocalize())", for: UIControl.State.normal)
        self.femaleButton.setTitle("    \("Female".toLocalize())", for: UIControl.State.normal)
        self.nonButton.setTitle("    \("Non_Binary".toLocalize())", for: UIControl.State.normal)
        self.arrow1ImageView.maskWith(color: UIColor.black)
        self.arrow2ImageView.maskWith(color: UIColor.black)
        self.arrow3ImageView.maskWith(color: UIColor.black)
    }
    
    @IBAction func onMaleButtonTap(_ sender: Any) {
        
        UserClass.setGender("1")
//        let view = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
//        view.selectedType = INPUT_TYPE.WEIGHT
//        self.navigationController?.pushViewController(view, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
    @IBAction func onFemaleButtonTap(_ sender: Any) {
        
        UserClass.setGender("2")
//        let view = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
//        view.selectedType = INPUT_TYPE.WEIGHT
//        self.navigationController?.pushViewController(view, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
    @IBAction func onNonButtonTap(_ sender: Any) {

        UserClass.setGender("0")
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
}
