//
//  AppDelegate.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit
import SwiftyStoreKit
import FBSDKCoreKit
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        }
        
        self.setupIAP()
        
        //Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if !Global.isAppLanguageSet() {
            let array : NSArray = Global.languageArray.value(forKey: "LanguageCode") as! NSArray
            if var str = NSLocale.current.languageCode {
                if str == "pt" {
                    str = "pt-PT"
                }
                if array.contains(str) {
                    Global.setLanguageCode(str)
                }
                else {
                    Global.setLanguageCode("en")
                }
            }
            else {
                Global.setLanguageCode("en")
            }
        }
        
        if UserClass.isUserSubscribe() && UserClass.isLogin() {
            Global.openDashboard()
        }
        else {
            Global.openGetStarted()
        }
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func setupIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
        self.checkWeeklySubscription()
    }
    
    func checkWeeklySubscription() {
        
        IAPHelper.subscribePayment(productId: PLANS.WEEKLY.rawValue) { (isPurchased) in
            UserClass.setWeeklySubscription(isPurchased)
            if !isPurchased {
                self.checkMonthlySubscription()
            }
        }
    }
    
    func checkMonthlySubscription() {
        
        IAPHelper.subscribePayment(productId: PLANS.MONTHLY.rawValue) { (isPurchased) in
            UserClass.setMonthlySubscription(isPurchased)
            if !isPurchased {
                self.checkYearlySubscription()
            }
        }
    }
    
    func checkYearlySubscription() {
        
        IAPHelper.subscribePayment(productId: PLANS.YEARLY.rawValue) { (isPurchased) in
            UserClass.setYearlySubscription(isPurchased)
        }
    }
}
