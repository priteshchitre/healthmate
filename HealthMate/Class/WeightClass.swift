//
//  WeightClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 6/11/20.
//

import UIKit

class WeightClass: NSObject {

    var weightId : String = ""
    var weight : Float = 0
    var date : String = ""
    var measurement : String = ""
    
    class func initWithData(_ data : NSDictionary) -> WeightClass {
        
        let object = WeightClass()
        
        object.weightId = AnyObjectRef(data.value(forKey: "weightId") as AnyObject).stringValue()
        object.date = AnyObjectRef(data.value(forKey: "date") as AnyObject).stringValue()
        object.weight = AnyObjectRef(data.value(forKey: "weight") as AnyObject).floatValue()
        object.measurement = AnyObjectRef(data.value(forKey: "measurement") as AnyObject).stringValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [WeightClass] {
        
        var array : [WeightClass] = []
        
        for i in 0..<data.count {
            array.append(WeightClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func updateRecord(_ object : WeightClass) {
        
        let dataArray = NSArray()
        var weightDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("weightData") {
            weightDic = dic
        }
        
        var weightArray = NSMutableArray()
        
        if let array = weightDic.value(forKey: "data") as? NSArray {
            weightArray = NSMutableArray(array: array)
        }
        
        let dic : NSDictionary = [
            "weightId":object.weightId,
            "date":object.date,
            "weight":object.weight,
            "measurement":object.measurement
        ]
        
        let filterArray = weightArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "weightId") as? String {
                    if str == object.weightId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            weightArray.remove(filterArray[0])
        }
        
        weightArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":weightArray
        ]
        Global.createJSONDetails("weightData", jsonData: newDic)
    }
    
    class func getweightArray() -> [WeightClass] {
        
        var dataArray : [WeightClass] = []
        
        if let dic = Global.getFileDetails("weightData") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = WeightClass.initWithArray(array)
            }
        }
        return dataArray
    }
}
