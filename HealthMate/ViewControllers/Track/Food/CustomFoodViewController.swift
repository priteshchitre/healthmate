//
//  CustomFoodViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit
import ActionSheetPicker_3_0

class CustomFoodViewController: UIViewController {

    @IBOutlet weak var foodNameTextField: CustomTextField!
    @IBOutlet weak var servingSizeTextField: CustomTextField!
    @IBOutlet weak var fatTextField: CustomTextField!
    @IBOutlet weak var carbTextField: CustomTextField!
    @IBOutlet weak var proteinTextField: CustomTextField!
    @IBOutlet weak var caloriesTextField: CustomTextField!
    
    var isAdd : Bool = false
    var foodObject : FoodClass = FoodClass()
    let backButton : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_CUSTOM_FOOD), object: nil)
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
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Custom_Food".toLocalize())
        self.foodNameTextField.placeholder = "Food_Name".toLocalize()
        self.servingSizeTextField.placeholder = "Serving_Size".toLocalize()
        self.fatTextField.placeholder = "Fat".toLocalize()
        self.carbTextField.placeholder = "Carb".toLocalize()
        self.proteinTextField.placeholder = "Protein".toLocalize()
        self.caloriesTextField.placeholder = "Calories_per_Serving".toLocalize()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setUpdateButton()
        
        self.foodNameTextField.delegate = self
        self.servingSizeTextField.delegate = self
        self.fatTextField.delegate = self
        self.carbTextField.delegate = self
        self.proteinTextField.delegate = self
        self.caloriesTextField.delegate = self
    }
    
    func initElements() {
        
        self.foodNameTextField.text = self.foodObject.foodName
        self.servingSizeTextField.text = self.foodObject.servingType
        
        if self.foodObject.carb != 0 {
            self.carbTextField.text = "\(self.foodObject.carb.toString())"
        }
        if self.foodObject.fat != 0 {
            self.fatTextField.text = "\(self.foodObject.fat.toString())"
        }
        if self.foodObject.protein != 0 {
            self.proteinTextField.text = "\(self.foodObject.protein.toString())"
        }
        if self.foodObject.calorie != 0 {
            self.caloriesTextField.text = "\(self.foodObject.calorie.toString())"
        }
    }
    
    func setUpdateButton() {

        self.backButton.setTitle( self.isAdd ? "Add".toLocalize() : "Update".toLocalize(), for: UIControl.State.normal)
        self.backButton.setTitleColor(Color.appGray, for: UIControl.State.normal)
        self.backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.backButton.addTarget(self, action: #selector(self.onupdateButtonTap), for: UIControl.Event.touchUpInside)
        self.backButton.contentMode = .scaleAspectFit
        self.backButton.sizeToFit()
        self.backButton.titleLabel?.textAlignment = .right
        self.backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onupdateButtonTap() {
        
        if self.foodNameTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_food_name".toLocalize())
            return
        }
        if self.servingSizeTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_serving".toLocalize())
            return
        }
        if self.caloriesTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_calories".toLocalize())
            return
        }
        
        self.foodObject.foodName = self.foodNameTextField.text?.trimmed() ?? ""
        self.foodObject.servingType = AnyObjectRef(self.servingSizeTextField.text as AnyObject).stringValue()
        self.foodObject.carb = AnyObjectRef(self.carbTextField.text as AnyObject).floatValue()
        self.foodObject.fat = AnyObjectRef(self.fatTextField.text as AnyObject).floatValue()
        self.foodObject.protein = AnyObjectRef(self.proteinTextField.text as AnyObject).floatValue()
        self.foodObject.calorie = AnyObjectRef(self.caloriesTextField.text as AnyObject).floatValue()
        FoodClass.updateRecord(self.foodObject)
        
        let alert = UIAlertController(title: Constants.APP_TITLE, message: self.isAdd ? "Food_added".toLocalize() : "Food_updated".toLocalize(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            if self.isAdd {
                NotificationCenter.default.post(name: NSNotification.Name("FoodListRefresh"), object: nil)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name("FoodDetailsRefresh"), object: self.foodObject)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkValidate() {
        
        if self.caloriesTextField.text == "" || self.foodNameTextField.text == "" || self.servingSizeTextField.text == ""  {
            self.backButton.titleLabel?.textColor = Color.appGray
        }
        else {
            self.backButton.titleLabel?.textColor = Color.appOrange
        }
    }
}
extension CustomFoodViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.checkValidate()
        }
        
        if textField == self.caloriesTextField || textField == self.fatTextField || textField == self.carbTextField || textField == self.proteinTextField {

            let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
            guard !s.isEmpty else { return true }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .none
            return numberFormatter.number(from: s)?.intValue != nil
        }
        return true
    }
}
