//
//  BirthDateSelectionViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class BirthDateSelectionViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var continueButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var birthDateTextField: DropDownTextField!
    @IBOutlet weak var continueButton: RoundButton!
    let datePicker = UIDatePicker()
    var selectedBirthDate : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.birthDateTextField.becomeFirstResponder()
    }
    
    func initView() {
        
        self.topLabel.text = "What_your_date_of_birth".toLocalize()
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.datePicker.maximumDate = Date()
        self.datePicker.datePickerMode = .date
        self.birthDateTextField.inputView = self.datePicker
        self.continueButton.backgroundColor = Color.disableGray
        
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        self.birthDateTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.continueButtonBottom.constant = 80.0
            } else {
                self.continueButtonBottom.constant = (endFrame?.size.height ?? 0) + 10
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func datePickerValueChanged(_ picker : UIDatePicker) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMMM yyyy"
        self.birthDateTextField.text = formatter.string(from: picker.date)
        formatter.dateFormat = "yyyy-MM-dd"
        self.selectedBirthDate = formatter.string(from: picker.date)
        self.continueButton.backgroundColor = Color.roundButtonColor
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        if self.birthDateTextField.text?.trimmed() == "" {
            Global.showError("Please_select_date_of_birth".toLocalize())
            return
        }
        UserClass.setBirthDate(self.selectedBirthDate)
//        let view = self.storyboard?.instantiateViewController(withIdentifier: "GenderSelectionViewController") as! GenderSelectionViewController
//        self.navigationController?.pushViewController(view, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
}
