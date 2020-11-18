//
//  FoodClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 30/10/20.
//

import UIKit

class FoodClass: NSObject {

    var foodId : String = ""
    var foodName : String = ""
    var servingType : String = ""
    var calorie : Float = 0
    var fat : Float = 0
    var carb : Float = 0
    var protein : Float = 0
    var orderNo : Int = 0
    
    class func initWithData(_ data : NSDictionary) -> FoodClass {
        
        let object = FoodClass()
        
        object.foodId = AnyObjectRef(data.value(forKey: "foodId") as AnyObject).stringValue()
        object.foodName = AnyObjectRef(data.value(forKey: "foodName") as AnyObject).stringValue()
        object.servingType = AnyObjectRef(data.value(forKey: "servingType") as AnyObject).stringValue()
        object.calorie = AnyObjectRef(data.value(forKey: "calorie") as AnyObject).floatValue()
        object.fat = AnyObjectRef(data.value(forKey: "fat") as AnyObject).floatValue()
        object.carb = AnyObjectRef(data.value(forKey: "carb") as AnyObject).floatValue()
        object.protein = AnyObjectRef(data.value(forKey: "protein") as AnyObject).floatValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [FoodClass] {
        
        var array : [FoodClass] = []
        
        for i in 0..<data.count {
            array.append(FoodClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func getFoodDictionary(_ object : FoodClass) -> NSMutableDictionary {
        
        let dic : NSDictionary = [
            "foodId":object.foodId,
            "foodName":object.foodName,
            "servingType":object.servingType,
            "calorie":object.calorie,
            "fat":object.fat,
            "carb":object.carb,
            "protein":object.protein
        ]
        return NSMutableDictionary(dictionary: dic)
    }
    
    class func updateRecord(_ object : FoodClass) {
        
        let dataArray = NSArray()
        var foodDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("food") {
            foodDic = dic
        }
        
        var foodArray = NSMutableArray()
        
        if let array = foodDic.value(forKey: "data") as? NSArray {
            foodArray = NSMutableArray(array: array)
        }
        let dic = FoodClass.getFoodDictionary(object)
        dic.setValue(foodArray.count, forKey: "orderNo")
        
//        let dic : NSDictionary = [
//            "foodId":object.foodId,
//            "foodName":object.foodName,
//            "servings":object.servings,
//            "servingType":object.servingType,
//            "calorie":object.calorie,
//            "fat":object.fat,
//            "carb":object.carb,
//            "protein":object.protein,
//            "orderNo":foodArray.count
//        ]
        
        let filterArray = foodArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "foodId") as? String {
                    if str == object.foodId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            foodArray.remove(filterArray[0])
        }
        
        foodArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":foodArray
        ]
        Global.createJSONDetails("food", jsonData: newDic)
    }
    
    class func deleteRecord(_ object : FoodClass) {
        
        let dataArray = NSArray()
        var foodDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("food") {
            foodDic = dic
        }
        
        var foodArray = NSMutableArray()
        
        if let array = foodDic.value(forKey: "data") as? NSArray {
            foodArray = NSMutableArray(array: array)
        }
        
        let filterArray = foodArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "foodId") as? String {
                    if str == object.foodId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            foodArray.remove(filterArray[0])
        }

        let newDic : NSDictionary = [
            "data":foodArray
        ]
        Global.createJSONDetails("food", jsonData: newDic)
    }
    
    class func getFoodArray() -> [FoodClass] {
        
        var dataArray : [FoodClass] = []
        
        if let dic = Global.getFileDetails("food") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = FoodClass.initWithArray(array)
            }
        }
        return dataArray
    }
}
