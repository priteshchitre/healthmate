//
//  SettingsInputViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 10/11/20.
//

import UIKit
import DropDown

class SettingsInputViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inputTextField: BoxTextField!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    
    let dropDown = DropDown()
    var isValid : Bool = false
    var selectedType : INPUT_TYPE = .WEIGHT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.inputTextField.resignFirstResponder()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setSaveBarButton()
        if self.selectedType == .HEIGHT {
            self.inputTextField.placeholder = "Height".toLocalize()
            self.setNavigationTitle(navigationItem: self.navigationItem, title: "Height".toLocalize())
        }
        else if self.selectedType == .WEIGHT {
            self.inputTextField.placeholder = "Current_weight".toLocalize()
            self.setNavigationTitle(navigationItem: self.navigationItem, title: "Current_weight".toLocalize())
        }
        else if self.selectedType == .EXPRECTED_WEIGHT {
            self.inputTextField.placeholder = "Weight_Goal".toLocalize()
            self.setNavigationTitle(navigationItem: self.navigationItem, title: "Weight_Goal".toLocalize())
        }

        self.inputTextField.delegate = self
        self.inputTextField.becomeFirstResponder()
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        self.dropDown.anchorView = self.dropdownView
        
        if self.selectedType == .WEIGHT || self.selectedType == .EXPRECTED_WEIGHT {
            self.dropDown.dataSource = ["kg", "lb"]
        }
        else if self.selectedType == .HEIGHT {
            self.dropDown.dataSource = ["cm", "inch"]
        }
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.dropdownView.bounds.height)
        // Action triggered on selection
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.measurementLabel.text = item
            self.validate(self.inputTextField.text ?? "")
            
           
        }
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.dropdownView.bounds.height)
        // Action triggered on selection
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.measurementLabel.text = item
            self.validate(self.inputTextField.text ?? "")
        }
        self.dropDown.width = 80
        
        if self.selectedType == .WEIGHT {
            self.inputTextField.text = UserClass.getWeight().toString()
            self.measurementLabel.text = UserClass.getWeightMeasurement()
        }
        else if self.selectedType == .HEIGHT {
            self.inputTextField.text = UserClass.getHeight().toString()
            self.measurementLabel.text = UserClass.getHeightMeasurement()
        }
        else if self.selectedType == .EXPRECTED_WEIGHT {
            self.inputTextField.text = UserClass.getExptectedWeight().toString()
            self.measurementLabel.text = UserClass.getExptectedWeightMeasurement()
        }
        
        self.validate(self.inputTextField.text ?? "")
        
        

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
    
    func validate(_ str : String) {
        
        if self.measurementLabel.text == "" || str == "" {
            self.isValid = false
            return
        }
        self.isValid = true
    }
    
    @IBAction func onDropDownButtonTap(_ sender: Any) {
        
        self.dropDown.show()
    }
    
    @objc func onSaveButtonTap(_ sender: Any) {
        
        if self.inputTextField.text?.trimmed() == "" {
            if self.selectedType == .WEIGHT {
                Global.showError("Please_enter_weight".toLocalize())
            }
            else if self.selectedType == .HEIGHT {
                Global.showError("Please_enter_height".toLocalize())
            }
            else if self.selectedType == .EXPRECTED_WEIGHT {
                Global.showError("Please_enter_weight".toLocalize())
            }
            return
        }
        if self.measurementLabel.text?.trimmed() == "" {
            Global.showError("Please_select_measurement".toLocalize())
            return
        }
        if !self.isValid {
            return
        }
        self.inputTextField.resignFirstResponder()
        
        if self.selectedType == .WEIGHT {
            UserClass.setWeightMeasurement(self.measurementLabel.text!)
            UserClass.setWeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
        }
        else if self.selectedType == .HEIGHT {
            UserClass.setHeightMeasurement(self.measurementLabel.text!)
            UserClass.setHeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
        }
        else if self.selectedType == .EXPRECTED_WEIGHT {
            UserClass.setExptectedWeightMeasurement(self.measurementLabel.text!)
            UserClass.setExptectedWeight(AnyObjectRef(self.inputTextField.text?.trimmed() as AnyObject).floatValue())
        }
        self.inputTextField.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}
extension SettingsInputViewController : UITextFieldDelegate {
    
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
