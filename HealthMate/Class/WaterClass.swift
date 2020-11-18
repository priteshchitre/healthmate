//
//  WaterClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 6/11/20.
//

import UIKit

class WaterClass: NSObject {

    var waterId : String = ""
    var waterValue : Float = 0
    var date : String = ""
    
    class func initWithData(_ data : NSDictionary) -> WaterClass {
        
        let object = WaterClass()
        
        object.waterId = AnyObjectRef(data.value(forKey: "waterId") as AnyObject).stringValue()
        object.date = AnyObjectRef(data.value(forKey: "date") as AnyObject).stringValue()
        object.waterValue = AnyObjectRef(data.value(forKey: "waterValue") as AnyObject).floatValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [WaterClass] {
        
        var array : [WaterClass] = []
        
        for i in 0..<data.count {
            array.append(WaterClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func updateRecord(_ object : WaterClass) {
        
        let dataArray = NSArray()
        var waterDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("waterData") {
            waterDic = dic
        }
        
        var waterArray = NSMutableArray()
        
        if let array = waterDic.value(forKey: "data") as? NSArray {
            waterArray = NSMutableArray(array: array)
        }
        
        let dic : NSDictionary = [
            "waterId":object.waterId,
            "date":object.date,
            "waterValue":object.waterValue
        ]
        
        let filterArray = waterArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "waterId") as? String {
                    if str == object.waterId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            waterArray.remove(filterArray[0])
        }
        
        waterArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":waterArray
        ]
        Global.createJSONDetails("waterData", jsonData: newDic)
    }
    
    class func getWaterArray() -> [WaterClass] {
        
        var dataArray : [WaterClass] = []
        
        if let dic = Global.getFileDetails("waterData") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = WaterClass.initWithArray(array)
            }
        }
        return dataArray
    }
    
}
