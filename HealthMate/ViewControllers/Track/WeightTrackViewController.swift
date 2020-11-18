//
//  WeightTrackViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 6/11/20.
//

import UIKit
import DropDown

class WeightTrackViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inputTextField: BoxTextField!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    
    let dropDown = DropDown()
    var isValid : Bool = false
    var selectedDate : Date = Date()
    var weightObject = WeightClass()
    
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
        self.setBackBarButton(true)
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Track_Weight".toLocalize())
        self.setCancelBarButton()
        self.setSaveBarButton()
        self.inputTextField.placeholder = "Weight".toLocalize()
        self.inputTextField.delegate = self
        self.inputTextField.becomeFirstResponder()
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        self.dropDown.anchorView = self.dropdownView
        self.dropDown.dataSource = ["kg", "lb"]
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.dropdownView.bounds.height)
        // Action triggered on selection
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.measurementLabel.text = item
            self.validate(self.inputTextField.text ?? "")
        }
        self.dropDown.width = 80
        self.validate(self.inputTextField.text ?? "")
        
        if self.weightObject.weight != 0 {
            self.isValid = true
            self.inputTextField.text = self.weightObject.weight.toString()
        }
        if self.weightObject.measurement == "" {
            self.measurementLabel.text = UserClass.getSettingWeight()
        }
        else {
            self.measurementLabel.text = self.weightObject.measurement
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
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
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
        self.inputTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        self.weightObject.measurement = self.measurementLabel.text!
        self.weightObject.date = formatter.string(from: self.selectedDate)
        self.weightObject.weight = AnyObjectRef(self.inputTextField.text as AnyObject).floatValue()
        WeightClass.updateRecord(self.weightObject)
        self.dismiss(animated: true, completion: nil)
    }
}
extension WeightTrackViewController : UITextFieldDelegate {
    
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
