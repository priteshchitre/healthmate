//
//  SingleInputeViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit
import DropDown

class SingleInputeViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: BoxTextField!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    
    var selectedType : INPUT_TYPE = .WEIGHT
    let dropDown = DropDown()
    var isValid : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.inputTextField.becomeFirstResponder()
    }
    
    func initView() {
        
        self.inputTextField.delegate = self
        self.inputTextField.becomeFirstResponder()
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        self.dropDown.anchorView = self.dropdownView
        if self.selectedType == .WEIGHT || self.selectedType == .EXPRECTED_WEIGHT {
            self.dropDown.dataSource = ["kg", "lb"]
            self.measurementLabel.text = UserClass.getWeightMeasurement()
        }
        else if self.selectedType == .HEIGHT {
            self.dropDown.dataSource = ["cm", "inch"]
            self.measurementLabel.text = UserClass.getHeightMeasurement()
        }
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.dropdownView.bounds.height)
        // Action triggered on selection
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.measurementLabel.text = item
            self.validate(self.inputTextField.text ?? "")
            
            if self.selectedType == .WEIGHT {
                UserClass.setWeightMeasurement(item)
                UserClass.setExptectedWeightMeasurement(item)
                UserClass.setSettingWeight(item)
            }
            else if self.selectedType == .HEIGHT {
                UserClass.setHeightMeasurement(item)
                UserClass.setSettingHeight(item)
            }
            else if self.selectedType == .EXPRECTED_WEIGHT {
                UserClass.setExptectedWeightMeasurement(item)
            }
        }
        self.dropDown.width = 80
        self.validate(self.inputTextField.text ?? "")
    }
    
    func initElements() {
        
        if self.selectedType == .WEIGHT {
            
            self.titleLabel.text = "How_much_do_your_current_weight".toLocalize()
        }
        else if self.selectedType == .HEIGHT {
            
            self.titleLabel.text = "How_tall_are_you".toLocalize()
        }
        else if self.selectedType == .EXPRECTED_WEIGHT {
            
            self.titleLabel.text = "How_much_would_you_like_to_weight".toLocalize()
        }
    }
    
    func validate(_ str : String) {
        
        if self.measurementLabel.text == "" || str == "" {
            self.continueButton.backgroundColor = Color.disableGray
            self.isValid = false
            return
        }
        //        else if let val = Float(str) {
        //            if val > 0 {
        //                self.continueButton.backgroundColor = Color.roundButtonColor
        //                self.isValid = true
        //                return
        //            }
        //        }
        self.continueButton.backgroundColor = Color.roundButtonColor
        self.isValid = true
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
                self.continueButtonBottom.constant = 25.0
            } else {
                self.continueButtonBottom.constant = (endFrame?.size.height ?? 0) + 10
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func onDropDownButtonTap(_ sender: Any) {
        
        self.dropDown.show()
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        if self.selectedType == .WEIGHT {
            
            if self.inputTextField.text?.trimmed() == "" {
                Global.showError("Please_enter_weight".toLocalize())
                return
            }
            if self.measurementLabel.text?.trimmed() == "" {
                Global.showError("Please_select_measurement".toLocalize())
                return
            }
            if !self.isValid {
                return
            }
            UserClass.setWeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
            self.view.endEditing(true)
            NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
        }
        else if self.selectedType == .HEIGHT {
            
            if self.inputTextField.text?.trimmed() == "" {
                Global.showError("Please_enter_height".toLocalize())
                return
            }
            if !self.isValid {
                return
            }
            UserClass.setHeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
            self.view.endEditing(true)
            NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
        }
        else if self.selectedType == .EXPRECTED_WEIGHT {
            
            if self.inputTextField.text?.trimmed() == "" {
                Global.showError("Please_enter_weight".toLocalize())
                return
            }
            if !self.isValid {
                return
            }
            UserClass.setExptectedWeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
            self.view.endEditing(true)
            NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
        }
    }
    
}
extension SingleInputeViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        self.validate(s)
        guard !s.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: s)?.intValue != nil
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.validate("")
        return true
    }
}
