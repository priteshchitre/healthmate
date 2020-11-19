//
//  NameViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 27/10/20.
//

import UIKit
import Purchases

class NameViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inputTextField: BoxTextField!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var continueButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        self.inputTextField.delegate = self
        self.inputTextField.becomeFirstResponder()
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.validate(self.inputTextField.text ?? "")
    }
    
    func initElements() {
        
        self.titleLabel.text = "\("Last_step".toLocalize())\n\("What_your_name".toLocalize())"
    }
    
    func validate(_ str : String) {
        
        if str == "" {
            self.continueButton.backgroundColor = Color.disableGray
            self.isValid = false
            return
        }
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
    
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        if self.inputTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_name".toLocalize())
            return
        }
        UserClass.setName((self.inputTextField.text?.trimmed())!)
        self.view.endEditing(true)
        Purchases.shared.identify(UserClass.getUserId()) { (purchaseInfo, error) in
            print("purchaseInfo = ",purchaseInfo ?? "")
            print("error = ", error ?? "")
        }
        NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
    }
}
extension NameViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        self.validate(s)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.validate("")
        return true
    }
}
