//
//  Global.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit
import SwiftMessages
import ReachabilitySwift

class Global: NSObject {

    static let heightRatio = UIScreen.main.bounds.size.height / 812
    static let widthRatio = UIScreen.main.bounds.size.width / 375

    static let languageArray : NSArray = [
        ["LanguageName":"English","LanguageCode":"en-US"],
        ["LanguageName":"Español","LanguageCode":"es"],
        ["LanguageName":"Français","LanguageCode":"fr"],
        ["LanguageName":"Português","LanguageCode":"pt-PT"],
        ["LanguageName":"Italiano","LanguageCode":"it"],
        ["LanguageName":"Pусский","LanguageCode":"ru"]]
    
    var workoutArray : [WorkoutClass] = []
    var calorieCalculatorArray : [CalorieCalculatorClass] = []
    
    class var sharedInstance : Global {
        struct Static {
            static let instance : Global = Global()
            
        }
        return Static.instance
    }
    
    class func showError(_ message : String) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Error".toLocalize(), body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.button?.isHidden = true
        view.configureTheme(.error, iconStyle: .default)
        view.accessibilityPrefix = "error"
        let config = SwiftMessages.defaultConfig
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showSuccess(_ message : String) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Success".toLocalize(), body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.button?.isHidden = true
        view.configureTheme(.success, iconStyle: .default)
        view.accessibilityPrefix = "success"
        let config = SwiftMessages.defaultConfig
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showNoNetworkAlert() {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Network_problem".toLocalize(), body: "Please_check_your_internet_connection".toLocalize(), iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.button?.isHidden = true
        view.configureTheme(.error, iconStyle: .default)
        view.accessibilityPrefix = "error"
        let config = SwiftMessages.defaultConfig
        SwiftMessages.show(config: config, view: view)
    }
    
    class func checkNetworkConnectivity() -> Bool {
        
        if Reachability()!.isReachable {
            return true
        }
        return false
    }
    
    class func showProgressHud() {
        SVProgressHUD.show()
    }
    
    class func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func openDashboard() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController")
        appDelegate.window?.rootViewController = view
        appDelegate.window?.makeKeyAndVisible()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.1
        if appDelegate.window != nil {
            UIView.transition(with: appDelegate.window!, duration: duration, options: options, animations: {}, completion:
                { completed in
            })
        }
    }
    
    class func openGetStarted() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if UserClass.isSubscribeScreen() {
            
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController")
            let navController = UINavigationController(rootViewController: view)
            appDelegate.window?.rootViewController = navController
        }
        else {
            
            let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetStartedViewController")
            let navController = UINavigationController(rootViewController: view)
            appDelegate.window?.rootViewController = navController
        }

        appDelegate.window?.makeKeyAndVisible()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.1
        if appDelegate.window != nil {
            UIView.transition(with: appDelegate.window!, duration: duration, options: options, animations: {}, completion:
                { completed in
            })
        }
    }
    
    class func getLocalFileDetails(_ fileName:String) -> NSDictionary? {
        
        let pathDirectory = Bundle.main.bundleURL.appendingPathComponent("\(fileName).json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pathDirectory.path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let result = jsonResult as? NSDictionary {
                return result
            }
            else {
                return nil
            }
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("paths = ", paths[0])
        return paths[0]
    }
    
    class func createJSONDetails(_ fileName : String, jsonData : NSDictionary) {
        
        let pathDirectory = Global.getDocumentsDirectory()
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        let filePath = pathDirectory.appendingPathComponent("\(fileName).json")
        
        do {
            if let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .init(rawValue: 0)) {
                try json.write(to: filePath)
            }
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
    }
    
    class func getFileDetails(_ fileName:String) -> NSDictionary? {
        
        let pathDirectory = Global.getDocumentsDirectory().appendingPathComponent("\(fileName).json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pathDirectory.path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let result = jsonResult as? NSDictionary {
                return result
            }
            else {
                return nil
            }
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            return nil
        }
    }
    
    class func removeFileDetails(_ fileName : String) {
        
        let pathDirectory = Global.getDocumentsDirectory().appendingPathComponent("\(fileName).json")
        if FileManager.default.fileExists(atPath: pathDirectory.path) {
            try? FileManager.default.removeItem(at: pathDirectory)
        }
    }
    
    class func setLanguageCode(_ languageCode : String) {
        UserDefaults.standard.setValue(languageCode, forKeyPath: "LanguageCode")
        UserDefaults.standard.synchronize()
    }
    
    class func getLanguageCode() -> String {
        if let languageCode = UserDefaults.standard.string(forKey: "LanguageCode") {
            return languageCode
        }
        return "en-US"
    }
    
    class func setIsAppLanguageSet(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isAppLanguageSet")
        UserDefaults.standard.synchronize()
    }
    
    class func isAppLanguageSet() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isAppLanguageSet") != nil {
            value = UserDefaults.standard.bool(forKey: "isAppLanguageSet")
        }
        return value
    }
    
    class func getConvertedHeight() -> Float {
        
        if UserClass.getHeightMeasurement().lowercased() == "cm" {
            
            if UserClass.getSettingHeight().lowercased() == "cm" {
                return UserClass.getHeight()
            }
            else {
                return UserClass.getHeight() / 2.54
            }
        }
        else {
            
            if UserClass.getSettingHeight().lowercased() == "cm" {
                return UserClass.getHeight() * 2.54
            }
            else {
                return UserClass.getHeight()
            }
        }
    }
    
    class func getConvertedWeight() -> Float {
        
        if UserClass.getWeightMeasurement().lowercased() == "kg" {
            
            if UserClass.getSettingWeight().lowercased() == "kg" {
                return UserClass.getWeight()
            }
            else {
                return UserClass.getWeight() * 2.205
            }
        }
        else {
            
            if UserClass.getSettingWeight().lowercased() == "kg" {
                return UserClass.getWeight() / 2.205
            }
            else {
                return UserClass.getWeight()
            }
        }
    }
    
    class func getConvertedGoalWeight() -> Float {
        
        if UserClass.getExptectedWeightMeasurement().lowercased() == "kg" {
            
            if UserClass.getSettingWeight().lowercased() == "kg" {
                return UserClass.getExptectedWeight()
            }
            else {
                return UserClass.getExptectedWeight() * 2.205
            }
        }
        else {
            
            if UserClass.getSettingWeight().lowercased() == "kg" {
                return UserClass.getExptectedWeight() / 2.205
            }
            else {
                return UserClass.getExptectedWeight()
            }
        }
    }
    
    class func getAge() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let birthdate = formatter.date(from: UserClass.getBirthDate()) {
            
            let ageComponents = Calendar.current.dateComponents([.year], from: birthdate, to: Date())
            guard let age = ageComponents.year else { return 0 }
            return age
        }
        return 0

    }
    
    class func getGender() -> String {
        
        if UserClass.getGender() == "1" {
            return "male"
        }
        if UserClass.getGender() == "2" {
            return "female"
        }
        return "nonbinary"
    }
    
    class func getActivityLevel() -> String {
        
        if UserClass.getActiveIndex() == 0 {
            return ACTIVITY_LEVEL.SENDETARY.rawValue
        }
        if UserClass.getActiveIndex() == 1 {
            return ACTIVITY_LEVEL.LIGHTLY_ACTIVE.rawValue
        }
        if UserClass.getActiveIndex() == 2 {
            return ACTIVITY_LEVEL.ACTIVE.rawValue
        }
        return ACTIVITY_LEVEL.VERY_ACTIVE.rawValue
    }
    
    class func getActivityArray() -> [String] {
        return ["Sedentary".toLocalize(), "Lightly_Active".toLocalize(), "Active".toLocalize(), "Very_Active".toLocalize()]
    }

    class func getActivityDescriptionArray() -> [String] {
        return ["Sedentary_details".toLocalize(), "Lightly_Active_details".toLocalize(), "Active_details".toLocalize(), "Very_Active_details".toLocalize()]
    }
    
    class func appVersion() -> String {
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    class func getCountryCode() -> String {
    
        var country : String = ""
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            country = countryCode
        }
        return country
    }
    
    class func getDeviceVersion() -> String {
        
        return UIDevice.current.systemVersion
    }
    
    class func getDeviceModelName() -> String {
        
        return UIDevice.modelName
    }
    
    class func addSubscriptionNotification() {
        
        if !UserClass.isUserSubscribe() {
            
            if UserClass.isSubscribeScreen() {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                let notificationDate = Date().addingTimeInterval(TimeInterval(10))
                let component = Calendar.current.dateComponents([.year,.day,.month,.hour,.minute,.second], from: notificationDate)
                let title = "\("Just_try_the_app_7_days_for_FREE".toLocalize())!🎁 :"
                let body = "\(UserClass.getName()), \("why_havent_you_started_a_free_trial".toLocalize())❓"
                Global.scheduleNotification(title, body: body, dateComponent: component, isRepeat: false, identifier: "reminder-1")
            }
        }
    }
    
    class func scheduleNotification(_ title : String, body: String, dateComponent : DateComponents, isRepeat : Bool, identifier : String) {
        
        let content      = UNMutableNotificationContent()
        content.title    = title
        content.body = body
        content.sound    = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isRepeat)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
        }
    }
}
public enum Result<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {


        let file = directoryFor(stringUrl: stringUrl)

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }

        DispatchQueue.global().async {

            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError()))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String) -> URL {

        let fileURL = URL(string: stringUrl)!.lastPathComponent

        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)

        return file
    }
}
