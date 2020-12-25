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
import Flurry_iOS_SDK
import OneSignal
import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FlurryMessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().isEnabled = false
        
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        }
        
        // TenjinSDK
        TenjinSDK.getInstance(Constants.TENJIN_KEY)
        TenjinSDK.connect()
        
        // OneSignalSDK
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Constants.ONESIGNAL_API_KEY,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            
        // RevenueCatSDK
        Purchases.debugLogsEnabled = true
        // Purchases.configure(withAPIKey: Constants.REVENUE_CAT_KEY)
        
        Purchases.configure(withAPIKey: Constants.REVENUE_CAT_KEY, appUserID: nil, observerMode: true)
        
        //FlurrySDK
        FlurryMessaging.setMessagingDelegate(self)
        Flurry.startSession(Constants.FLURRY_KEY, with: FlurrySessionBuilder
                                .init()
                                .withIAPReportingEnabled(true)
                                .withCrashReporting(true)
                                .withLogLevel(FlurryLogLevelAll)
                                .withIncludeBackgroundSessions(inMetrics: true))
        
        self.setupIAP()
        
        // Facebook
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
        self.getAppConfig()
        if UserClass.isUserSubscribe() && UserClass.isLogin() {
            Global.openDashboard()
        }
        else {
            Global.openGetStarted()
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        FlurryMessaging.setDeviceToken(deviceToken)
    }
    
    func didReceive(_ message: FlurryMessage) {
        
        print("message = ", message)
    }
    
    func didReceiveAction(withIdentifier identifier: String?, message: FlurryMessage) {
        
//        print("identifier = ", identifier)
//        print("message = ", message)
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
                self.checkWeekly3DaysSubscription()
            }
        }
    }
    
    func checkWeekly3DaysSubscription() {
        
        IAPHelper.subscribePayment(productId: PLANS.WEEKLY_3DAYS_TRIAL.rawValue) { (isPurchased) in
            UserClass.setWeekly3DaysSubscription(isPurchased)
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
    
    func getAppConfig() {
        
        if !Global.checkNetworkConnectivity() {
            return
        }
        APIHelperClass.sharedInstance.getRequest("\(APIHelperClass.config)?version=\(Global.appVersion())", parameters: NSMutableDictionary()) { (result, error, statusCode) in
            
            if statusCode == 200 {
                UserClass.setSubscriptionConfig(AnyObjectRef(result?.value(forKey: "storeScreenVariant") as AnyObject).intValue())
                UserClass.setWeeklySubscriptionId(AnyObjectRef(result?.value(forKey: "weeklySubscriptionId") as AnyObject).stringValue())
                UserClass.setDaysFree(AnyObjectRef(result?.value(forKey: "daysFree") as AnyObject).intValue())
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        Global.addSubscriptionNotification()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Global.addSubscriptionNotification()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
