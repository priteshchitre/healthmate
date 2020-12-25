//
//  UserClass.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit
import Purchases

class UserClass: NSObject {
    
    class func setUserId(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "userId")
        UserDefaults.standard.synchronize()
    }
    
    class func getUserId() -> String {
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "userId") != nil {
            value = UserDefaults.standard.string(forKey: "userId") ?? ""
        }

        // Generate random one and sync it in local storage
        if value == "" {
            value = UUID().uuidString
            UserClass.setUserId(value)
        }

        return value
    }
    
    class func setSubscriptionConfig(_ value : Int) {
        UserDefaults.standard.setValue(value, forKey: "subscriptionConfig")
        UserDefaults.standard.synchronize()
    }
    
    class func getSubscriptionConfig() -> Int {
        
        var value : Int = 1
        if  UserDefaults.standard.object(forKey: "subscriptionConfig") != nil {
            value = UserDefaults.standard.integer(forKey: "subscriptionConfig")
        }
        return value
    }
    
    class func setDaysFree(_ value : Int) {
        UserDefaults.standard.setValue(value, forKey: "daysFree")
        UserDefaults.standard.synchronize()
    }
    
    class func getDaysFree() -> Int {
        
        var value : Int = 7
        if  UserDefaults.standard.object(forKey: "daysFree") != nil {
            value = UserDefaults.standard.integer(forKey: "daysFree")
        }
        return value
    }
    
    class func setWeeklySubscriptionId(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "weeklySubscriptionId")
        UserDefaults.standard.synchronize()
    }
    
    class func getWeeklySubscriptionId() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "weeklySubscriptionId") != nil {
            value = UserDefaults.standard.string(forKey: "weeklySubscriptionId") ?? ""
        }
        if value == "" {
            value = PLANS.WEEKLY.rawValue
        }
        return value
    }
    
    class func setIsLogin(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isLogin")
        UserDefaults.standard.synchronize()
    }
    
    class func isLogin() -> Bool {
        
        var value : Bool = true
        if  UserDefaults.standard.object(forKey: "isLogin") != nil {
            value = UserDefaults.standard.bool(forKey: "isLogin")
        }
        return value
    }
    
    class func setSettingWeight(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "settingWeight")
        UserDefaults.standard.synchronize()
    }
    
    class func getSettingWeight() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "kg" : "lb"
        if  UserDefaults.standard.object(forKey: "settingWeight") != nil {
            value = UserDefaults.standard.string(forKey: "settingWeight") ?? ""
        }
        return value
    }
    
    class func setSettingHeight(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "settingHeight")
        UserDefaults.standard.synchronize()
    }
    
    class func getSettingHeight() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "cm" : "inch"
        if  UserDefaults.standard.object(forKey: "settingHeight") != nil {
            value = UserDefaults.standard.string(forKey: "settingHeight") ?? ""
        }
        return value
    }
    
    class func setSettingWater(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "settingWater")
        UserDefaults.standard.synchronize()
    }
    
    class func getSettingWater() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "ml" : "oz"
        if  UserDefaults.standard.object(forKey: "settingWater") != nil {
            value = UserDefaults.standard.string(forKey: "settingWater") ?? ""
        }
        return value
    }
    
    class func setGoalCalories(_ value : Float) {
        UserDefaults.standard.setValue(value, forKey: "goalCalories")
        UserDefaults.standard.synchronize()
    }
    
    class func getGoalCalories() -> Float {
        
        var value : Float = 0
        if  UserDefaults.standard.object(forKey: "goalCalories") != nil {
            value = UserDefaults.standard.float(forKey: "goalCalories")
        }
        return value
    }
    
    class func setProfileURL(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "profileURL")
        UserDefaults.standard.synchronize()
    }
    
    class func getProfileURL() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "profileURL") != nil {
            value = UserDefaults.standard.string(forKey: "profileURL") ?? ""
        }
        return value
    }
    
    class func setEmail(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "email")
        UserDefaults.standard.synchronize()
    }
    
    class func getEmail() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "email") != nil {
            value = UserDefaults.standard.string(forKey: "email") ?? ""
        }
        return value
    }
    
    class func setAppleUserId(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "appleUserId")
        UserDefaults.standard.synchronize()
    }
    
    class func getAppleUserId() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "appleUserId") != nil {
            value = UserDefaults.standard.string(forKey: "appleUserId") ?? ""
        }
        return value
    }
    
    class func setFacebookUserId(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "facebookUserId")
        UserDefaults.standard.synchronize()
    }
    
    class func getFacebookUserId() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "facebookUserId") != nil {
            value = UserDefaults.standard.string(forKey: "facebookUserId") ?? ""
        }
        return value
    }
    
    class func setBirthDate(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "birthDate")
        UserDefaults.standard.synchronize()
    }
    
    class func getBirthDate() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "birthDate") != nil {
            value = UserDefaults.standard.string(forKey: "birthDate") ?? ""
        }
        return value
    }
    
    class func setWeight(_ value : Float) {
        UserDefaults.standard.setValue(value, forKey: "weight")
        UserDefaults.standard.synchronize()
    }
    
    class func getWeight() -> Float {
        
        var value : Float = 0
        if  UserDefaults.standard.object(forKey: "weight") != nil {
            value = UserDefaults.standard.float(forKey: "weight")
        }
        return value
    }
    
    class func setWeightMeasurement(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "weightMeasurement")
        UserDefaults.standard.synchronize()
    }
    
    class func getWeightMeasurement() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "kg" : "lb"
        
        if  UserDefaults.standard.object(forKey: "weightMeasurement") != nil {
            value = UserDefaults.standard.string(forKey: "weightMeasurement") ?? ""
        }
        return value
    }
    
    class func setHeight(_ value : Float) {
        UserDefaults.standard.setValue(value, forKey: "height")
        UserDefaults.standard.synchronize()
    }
    
    class func getHeight() -> Float {
        
        var value : Float = 0
        if  UserDefaults.standard.object(forKey: "height") != nil {
            value = UserDefaults.standard.float(forKey: "height")
        }
        return value
    }
    
    class func setHeightMeasurement(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "heightMeasurement")
        UserDefaults.standard.synchronize()
    }
    
    class func getHeightMeasurement() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "cm" : "inch"
        if  UserDefaults.standard.object(forKey: "heightMeasurement") != nil {
            value = UserDefaults.standard.string(forKey: "heightMeasurement") ?? ""
        }
        return value
    }
    
    class func setExptectedWeight(_ value : Float) {
        UserDefaults.standard.setValue(value, forKey: "exptectedWeight")
        UserDefaults.standard.synchronize()
    }
    
    class func getExptectedWeight() -> Float {
        
        var value : Float = 0
        if  UserDefaults.standard.object(forKey: "exptectedWeight") != nil {
            value = UserDefaults.standard.float(forKey: "exptectedWeight")
        }
        return value
    }
    
    class func setExptectedWeightMeasurement(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "exptectedWeightMeasurement")
        UserDefaults.standard.synchronize()
    }
    
    class func getExptectedWeightMeasurement() -> String {
        
        var value : String = Locale.current.usesMetricSystem ? "kg" : "lb"
        if  UserDefaults.standard.object(forKey: "exptectedWeightMeasurement") != nil {
            value = UserDefaults.standard.string(forKey: "exptectedWeightMeasurement") ?? ""
        }
        return value
    }
    
    class func setActiveIndex(_ value : Int) {
        UserDefaults.standard.setValue(value, forKey: "activeIndex")
        UserDefaults.standard.synchronize()
    }
    
    class func getActiveIndex() -> Int {
        
        var value : Int = 0
        if  UserDefaults.standard.object(forKey: "activeIndex") != nil {
            value = UserDefaults.standard.integer(forKey: "activeIndex")
        }
        return value
    }
    
    class func setGoalAction(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "goalAction")
        UserDefaults.standard.synchronize()
    }
    
    class func getGoalAction() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "goalAction") != nil {
            value = UserDefaults.standard.string(forKey: "goalAction") ?? ""
        }
        return value
    }
    
    class func setName(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "name")
        UserDefaults.standard.synchronize()
    }
    
    class func getName() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "name") != nil {
            value = UserDefaults.standard.string(forKey: "name") ?? ""
        }
        return value
    }
    
    class func setGender(_ value : String) {
        UserDefaults.standard.setValue(value, forKey: "gender")
        UserDefaults.standard.synchronize()
    }
    
    class func getGender() -> String {
        
        var value : String = ""
        if  UserDefaults.standard.object(forKey: "gender") != nil {
            value = UserDefaults.standard.string(forKey: "gender") ?? ""
        }
        return value
    }
    
    //Subscription Manage
    
    class func isUserSubscribe() -> Bool {
        
//        return true
        if UserClass.isWeeklySubscription() || UserClass.isWeekly3DaysSubscription() || UserClass.isMonthlySubscription() || UserClass.isYearlySubscription() {
            return true
        }
        return false
    }
    
    
    class func setSubscribeScreen(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isSubscribeScreen")
        UserDefaults.standard.synchronize()
    }
    
    class func isSubscribeScreen() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isSubscribeScreen") != nil {
            value = UserDefaults.standard.bool(forKey: "isSubscribeScreen")
        }
        return value
    }
    
    class func setWeekly3DaysSubscription(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isWeekly3DaysSubscription")
        UserDefaults.standard.synchronize()
    }
    
    class func isWeekly3DaysSubscription() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isWeekly3DaysSubscription") != nil {
            value = UserDefaults.standard.bool(forKey: "isWeekly3DaysSubscription")
        }
        return value
    }
    
    class func setWeeklySubscription(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isWeeklySubscription")
        UserDefaults.standard.synchronize()
    }
    
    class func isWeeklySubscription() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isWeeklySubscription") != nil {
            value = UserDefaults.standard.bool(forKey: "isWeeklySubscription")
        }
        return value
    }
    
    class func setMonthlySubscription(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isMonthlySubscription")
        UserDefaults.standard.synchronize()
    }
    
    class func isMonthlySubscription() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isMonthlySubscription") != nil {
            value = UserDefaults.standard.bool(forKey: "isMonthlySubscription")
        }
        return value
    }
    
    class func setYearlySubscription(_ value : Bool) {
        UserDefaults.standard.setValue(value, forKey: "isYearlySubscription")
        UserDefaults.standard.synchronize()
    }
    
    class func isYearlySubscription() -> Bool {
        
        var value : Bool = false
        if  UserDefaults.standard.object(forKey: "isYearlySubscription") != nil {
            value = UserDefaults.standard.bool(forKey: "isYearlySubscription")
        }
        return value
    }
    
    class func resetUser() {
        
        UserClass.setName("")
        UserClass.setEmail("")
        UserClass.setUserId("")
        UserClass.setIsLogin(false)
        UserClass.setWeekly3DaysSubscription(false)
        UserClass.setWeeklySubscription(false)
        UserClass.setMonthlySubscription(false)
        UserClass.setYearlySubscription(false)
        UserClass.setSubscribeScreen(false)
        Global.removeFileDetails("food")
        Global.removeFileDetails("consumeData")
        Global.removeFileDetails("burnedData")
        Global.removeFileDetails("exercise")
        Global.removeFileDetails("waterData")
        Global.removeFileDetails("weightData")

        Purchases.shared.reset() { (purchaseInfo, error) in
            print("purchaseInfo = ",purchaseInfo ?? "")
            print("error = ", error ?? "")
        }
    }
}
