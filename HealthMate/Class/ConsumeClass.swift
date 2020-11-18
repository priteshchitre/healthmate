//
//  ConsumeClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 4/11/20.
//

import UIKit

class ConsumeClass: NSObject {

    var consumeId : String = ""
    var date : String = ""
    var servings : Float = 0
    var mealType : Int = 0
    var foodDetails = NSDictionary()
    var foodObject = FoodClass()
    
    class func initWithData(_ data : NSDictionary) -> ConsumeClass {
        
        let object = ConsumeClass()
        
        object.consumeId = AnyObjectRef(data.value(forKey: "consumeId") as AnyObject).stringValue()
        object.date = AnyObjectRef(data.value(forKey: "date") as AnyObject).stringValue()
        object.servings = AnyObjectRef(data.value(forKey: "servings") as AnyObject).floatValue()
        object.mealType = AnyObjectRef(data.value(forKey: "mealType") as AnyObject).intValue()
        if let dic = data.value(forKey: "foodDetails") as? NSDictionary {
            object.foodDetails = dic
            object.foodObject = FoodClass.initWithData(object.foodDetails)
        }

        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [ConsumeClass] {
        
        var array : [ConsumeClass] = []
        
        for i in 0..<data.count {
            array.append(ConsumeClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func updateRecord(_ object : ConsumeClass, foodObject : FoodClass) {
        
        let dataArray = NSArray()
        var consumedDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("consumeData") {
            consumedDic = dic
        }
        
        var consumedArray = NSMutableArray()
        
        if let array = consumedDic.value(forKey: "data") as? NSArray {
            consumedArray = NSMutableArray(array: array)
        }
        
        let dic : NSDictionary = [
            "consumeId":object.consumeId,
            "date":object.date,
            "servings":object.servings,
            "mealType":object.mealType,
            "foodDetails":FoodClass.getFoodDictionary(foodObject)
        ]
        
        let filterArray = consumedArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "consumeId") as? String {
                    if str == object.consumeId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            consumedArray.remove(filterArray[0])
        }
        
        consumedArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":consumedArray
        ]
        Global.createJSONDetails("consumeData", jsonData: newDic)
    }
    
    class func deleteRecord(_ object : ConsumeClass) {
        
        let dataArray = NSArray()
        var consumedDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("consumeData") {
            consumedDic = dic
        }
        
        var consumedArray = NSMutableArray()
        
        if let array = consumedDic.value(forKey: "data") as? NSArray {
            consumedArray = NSMutableArray(array: array)
        }
        
        let filterArray = consumedArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "consumeId") as? String {
                    if str == object.consumeId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            consumedArray.remove(filterArray[0])
        }

        let newDic : NSDictionary = [
            "data":consumedArray
        ]
        Global.createJSONDetails("consumeData", jsonData: newDic)
    }
    
    class func getConsumeArray() -> [ConsumeClass] {
        
        var dataArray : [ConsumeClass] = []
        
        if let dic = Global.getFileDetails("consumeData") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = ConsumeClass.initWithArray(array)
            }
        }
        return dataArray
    }
}
