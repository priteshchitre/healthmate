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
            NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
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
        NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
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
            "idfa": "30255BCE-4CDA-4F62-91DC-4758FDFF8512",
            "device": "iPhone",
            "deviceModel": "6S",
            "os": "ios",
            "osVersion": "12.4.1"
        ]
        
        Global.showProgressHud()
        
        APIHelperClass.sharedInstance.postRequest("\(APIHelperClass.signup)", parameters: param) { (result, error, statusCode) in

            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    
                }
            }
        }
    }
}
