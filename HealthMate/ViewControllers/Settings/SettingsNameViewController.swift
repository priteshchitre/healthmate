//
//  SettingsNameViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 11/11/20.
//

import UIKit

class SettingsNameViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inputTextField: BoxTextField!
    
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
        self.inputTextField.placeholder = "Name".toLocalize()
        self.inputTextField.becomeFirstResponder()
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.inputTextField.text = UserClass.getName()
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

    @objc func onSaveButtonTap(_ sender: Any) {
        
        if self.inputTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_name".toLocalize())
            return
        }
        UserClass.setName((self.inputTextField.text?.trimmed())!)
        self.inputTextField.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}
