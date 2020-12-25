//
//  AppleUserClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 20/11/20.
//

import UIKit

class AppleUserClass: NSObject {

    var userId : String = ""
    var name : String = ""
    var email : String = ""
    
    class func initWithData(_ data : NSDictionary) -> AppleUserClass {
        
        let object = AppleUserClass()
        
        object.userId = AnyObjectRef(data.value(forKey: "userId") as AnyObject).stringValue()
        object.name = AnyObjectRef(data.value(forKey: "name") as AnyObject).stringValue()
        object.email = AnyObjectRef(data.value(forKey: "email") as AnyObject).stringValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [AppleUserClass] {
        
        var array : [AppleUserClass] = []
        
        for i in 0..<data.count {
            array.append(AppleUserClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func getAppleUserDictionary(_ object : AppleUserClass) -> NSMutableDictionary {
        
        let dic : NSDictionary = [
            "userId":object.userId,
            "name":object.name,
            "email":object.email
        ]
        return NSMutableDictionary(dictionary: dic)
    }
    
    class func updateRecord(_ object : AppleUserClass) {
        
        let dataArray = NSArray()
        var userDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("appleUser") {
            userDic = dic
        }
        
        var appleUserArray = NSMutableArray()
        
        if let array = userDic.value(forKey: "data") as? NSArray {
            appleUserArray = NSMutableArray(array: array)
        }
        let dic = AppleUserClass.getAppleUserDictionary(object)
        dic.setValue(appleUserArray.count, forKey: "orderNo")
        
        let filterArray = appleUserArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "userId") as? String {
                    if str == object.userId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            appleUserArray.remove(filterArray[0])
        }
        
        appleUserArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":appleUserArray
        ]
        Global.createJSONDetails("appleUser", jsonData: newDic)
    }
    
    class func getAppleUserArray() -> [AppleUserClass] {
        
        var dataArray : [AppleUserClass] = []
        
        if let dic = Global.getFileDetails("appleUser") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = AppleUserClass.initWithArray(array)
            }
        }
        return dataArray
    }
}
