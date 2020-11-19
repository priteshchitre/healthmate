//
//  CaloriesBurnedViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit

class CaloriesBurnedViewController: UIViewController {

    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var caloriesTextField: CustomTextField!
    
    var isAdd : Bool = false
    var exerciseObject  = ExerciseClass()
    var selectedDate = Date()
    let backButton : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setUpdateButton()
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Exercise_Calories".toLocalize())
        self.nameTextField.placeholder = "Name".toLocalize()
        
        if self.exerciseObject.isCustomExercise {
            self.caloriesTextField.placeholder = "Calorie_Burned_Rate".toLocalize()
        }
        else {
            self.caloriesTextField.placeholder = "Calories_burned".toLocalize()
        }

        
        self.caloriesTextField.delegate = self
        self.nameTextField.delegate = self
    }
    
    func initElements() {
        
        self.nameTextField.text = self.exerciseObject.name
        
        if self.exerciseObject.calorie != 0 {
            self.caloriesTextField.text = "\(self.exerciseObject.calorie.toRound())"
        }
    }
    
    func setUpdateButton() {

        self.backButton.setTitle( self.isAdd ? "Done".toLocalize() : "Update".toLocalize(), for: UIControl.State.normal)
        self.backButton.setTitleColor(Color.appGray, for: UIControl.State.normal)
        self.backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.backButton.addTarget(self, action: #selector(self.onupdateButtonTap), for: UIControl.Event.touchUpInside)
        self.backButton.contentMode = .scaleAspectFit
        self.backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        self.backButton.sizeToFit()
        self.backButton.titleLabel?.textAlignment = .right
        let backBarButton = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onupdateButtonTap() {
        
        if self.nameTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_name".toLocalize())
            return
        }
        if self.caloriesTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_calories".toLocalize())
            return
        }
        
        self.exerciseObject.name = self.nameTextField.text?.trimmed() ?? ""
        self.exerciseObject.calorie = AnyObjectRef(self.caloriesTextField.text as AnyObject).floatValue()
        ExerciseClass.updateRecord(self.exerciseObject)
        
        if self.isAdd {
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseCaloriesDetailsViewController") as! ExerciseCaloriesDetailsViewController
            view.exerciseObject = self.exerciseObject
            view.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(view, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name("ExerciseCaloriesDetailsRefresh"), object: self.exerciseObject)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func nameValidate(_ str : String) {
        
        if self.caloriesTextField.text == "" || str == "" {
            self.backButton.titleLabel?.textColor = Color.appGray
        }
        else {
            self.backButton.titleLabel?.textColor = Color.appOrange
        }
    }
    
    func calorieValidate(_ str : String) {
        
        if self.nameTextField.text == "" || str == "" {
            self.backButton.titleLabel?.textColor = Color.appGray
        }
        else {
            self.backButton.titleLabel?.textColor = Color.appOrange
        }
    }
}
extension CaloriesBurnedViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.caloriesTextField  {

            let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            self.calorieValidate(s)
            guard !s.isEmpty else { return true }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .none
            return numberFormatter.number(from: s)?.intValue != nil
        }
        if textField == self.nameTextField  {

            let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            self.nameValidate(s)
        }
        return true
    }
}
