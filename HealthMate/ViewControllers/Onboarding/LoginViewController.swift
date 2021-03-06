//
//  LoginViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit
import FBSDKCoreKit
import Purchases

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: SquareTextField!
    @IBOutlet weak var emailTextField: SquareTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var facebookTop: NSLayoutConstraint!
    @IBOutlet weak var skipButtonTop: NSLayoutConstraint!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var appleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var appleViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    func initView() {
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            
            self.titleTop.constant = 10
//            self.facebookTop.constant = 10
            self.skipButtonTop.constant = 10
        }
        self.continueButton.backgroundColor = Color.appOrange
        self.continueButton.layer.cornerRadius = 8
        self.facebookButton.layer.cornerRadius = 8
        
        self.titleLabel.text = "Welcome_to_Health_Mate".toLocalize()
        self.subTitleLabel.text = "Create_an_account_now_to_get_started_on_your_health_journey".toLocalize()
        
        self.nameTextField.placeholder = "Your_full_name".toLocalize()
        self.emailTextField.placeholder = "Your_Email_Address".toLocalize()
        
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        self.facebookButton.setTitle("Continue_with_Facebook".toLocalize(), for: UIControl.State.normal)
        self.skipButton.setTitle("Skip_Registration".toLocalize(), for: UIControl.State.normal)
        
        if #available(iOS 13.0, *) {
            self.setUpSignInAppleButton()
        }
        else {
            self.appleViewHeight.constant = 0
            self.appleView.isHidden = true
            self.appleViewTop.constant = 0
        }
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
    }
    
    func setUpSignInAppleButton() {
        
        if #available(iOS 13.0, *) {
            
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            self.appleView.layoutIfNeeded()
            authorizationButton.frame = CGRect(x: 0, y: 0, width: self.appleView.frame.size.width, height: self.appleView.frame.size.height)
            authorizationButton.cornerRadius = 5
            //Add button on some view or stack
            self.appleView.addSubview(authorizationButton)
        }
    }
    
    @objc func handleAppleIdRequest() {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            if let str = fullName?.givenName {
                UserClass.setName(str)
            }
            if let str = email {
                UserClass.setEmail(str)
            }
            UserClass.setAppleUserId(userIdentifier)
            
            if UserClass.getName() == "" || UserClass.getEmail() == "" {
                
                let array = AppleUserClass.getAppleUserArray()
                let filter = array.filter { (obj) -> Bool in
                    return obj.userId == UserClass.getAppleUserId()
                }
                
                if filter.count > 0 {
                    UserClass.setName(filter[0].name)
                    UserClass.setEmail(filter[0].email)
                }
            }
            
            let appleObject = AppleUserClass()
            appleObject.name = UserClass.getName()
            appleObject.email = UserClass.getEmail()
            appleObject.userId = UserClass.getAppleUserId()
            AppleUserClass.updateRecord(appleObject)
            
            self.register()
            //NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        if self.nameTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_name".toLocalize())
            return
        }
        if self.emailTextField.text?.trimmed() == "" {
            Global.showError("Please_enter_email".toLocalize())
            return
        }
        if !self.emailTextField.text!.isValidEmail() {
            Global.showError("Please_enter_valid_email".toLocalize())
            return
        }
        UserClass.setName((self.nameTextField.text?.trimmed())!)
        UserClass.setEmail((self.emailTextField.text?.trimmed())!)
        self.view.endEditing(true)
        self.register()
//        NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
    }
    
    @IBAction func onFacebookButtonTap(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Error = ", error ?? "")
            }
            self.facebookLoggedIn()
        }
    }
    
    func facebookLoggedIn()  {
        
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name, last_name, picture.type(large)"])
        request.start { (connection, result, error) in
            
            if error != nil {
                return
            }
            if let dic = result as? NSDictionary {
                
                if let str = dic.value(forKey: "email") as? String {
                    UserClass.setEmail(str)
                }
                if let str = dic.value(forKey: "name") as? String {
                    UserClass.setName(str)
                }
                if let pictureDic = dic.value(forKey: "picture") as? NSDictionary {
                    if let dataDic = pictureDic.value(forKey: "data") as? NSDictionary {
                        if let url = dataDic.value(forKey: "url") as? String {
                            UserClass.setProfileURL(url)
                        }
                    }
                }
                self.register()
                //NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
            }
        }
    }
    
    @IBAction func onSkipButtonTap(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
    
    func register() {
        
        if !Global.checkNetworkConnectivity() {
            return
        }
        
        let param : NSMutableDictionary = [
            "fullname": UserClass.getName(),
            "email": UserClass.getEmail(),
            "idfa": Global.getUniqueId(),
            "device": UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone",
            "deviceModel": Global.getDeviceModelName(),
            "os": "ios",
            "osVersion": Global.getDeviceVersion()
        ]
        
        Global.showProgressHud()
        
        APIHelperClass.sharedInstance.postRequest("\(APIHelperClass.signup)", parameters: param) { (result, error, statusCode) in

            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            if let dataDic = result {
                if let userId = dataDic.value(forKey: "userId") as? String {
                    UserClass.setUserId(userId)
                }
            }
            Purchases.shared.identify(UserClass.getUserId()) { (purchaseInfo, error) in
                print("purchaseInfo = ",purchaseInfo ?? "")
                print("error = ", error ?? "")
            }
            NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
        }
    }
}
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if self.nameTextField == textField {
            
            self.emailTextField.becomeFirstResponder()
        }
        else if self.emailTextField == textField {
            textField.resignFirstResponder()
        }
        return true
    }
}
