//
//  BurnedClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit

class BurnedClass: NSObject {

    var burnedId : String = ""
    var date : String = ""
    var calories : Float = 0
    var duration : Int = 0
    var isCustomExercise : Bool = false
    var isSearchExercise : Bool = false
    var isWorkout : Bool = false
    var exerciseDetails = NSDictionary()
    var exerciseObject = ExerciseClass()
    var activityDetails = NSDictionary()
    var activityObject = ActivityClass()
    
    class func initWithData(_ data : NSDictionary) -> BurnedClass {
        
        let object = BurnedClass()
        
        object.burnedId = AnyObjectRef(data.value(forKey: "burnedId") as AnyObject).stringValue()
        object.date = AnyObjectRef(data.value(forKey: "date") as AnyObject).stringValue()
        object.calories = AnyObjectRef(data.value(forKey: "calories") as AnyObject).floatValue()
        object.duration = AnyObjectRef(data.value(forKey: "duration") as AnyObject).intValue()
        object.isCustomExercise = AnyObjectRef(data.value(forKey: "isCustomExercise") as AnyObject).boolValue()
        object.isSearchExercise = AnyObjectRef(data.value(forKey: "isSearchExercise") as AnyObject).boolValue()
        object.isWorkout = AnyObjectRef(data.value(forKey: "isWorkout") as AnyObject).boolValue()
        if let dic = data.value(forKey: "exerciseDetails") as? NSDictionary {
            object.exerciseDetails = dic
            object.exerciseObject = ExerciseClass.initWithData(object.exerciseDetails)
        }
        if let dic = data.value(forKey: "activityDetails") as? NSDictionary {
            object.activityDetails = dic
            object.activityObject = ActivityClass.initWithData(object.activityDetails)
        }
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [BurnedClass] {
        
        var array : [BurnedClass] = []
        
        for i in 0..<data.count {
            array.append(BurnedClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func updateRecord(_ object : BurnedClass, exerciseObject : ExerciseClass, activityObject : ActivityClass) {
        
        let dataArray = NSArray()
        var burnedDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("burnedData") {
            burnedDic = dic
        }
        
        var burnedArray = NSMutableArray()
        
        if let array = burnedDic.value(forKey: "data") as? NSArray {
            burnedArray = NSMutableArray(array: array)
        }
        
        let dic : NSDictionary = [
            "burnedId":object.burnedId,
            "date":object.date,
            "calories":object.calories,
            "duration":object.duration,
            "isCustomExercise":object.isCustomExercise,
            "isSearchExercise":object.isSearchExercise,
            "isWorkout":object.isWorkout,
            "exerciseDetails":ExerciseClass.getExerciseDictionary(exerciseObject),
            "activityDetails":ActivityClass.getActivityDictionary(activityObject)
        ]
        
        let filterArray = burnedArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "burnedId") as? String {
                    if str == object.burnedId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            burnedArray.remove(filterArray[0])
        }
        
        burnedArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":burnedArray
        ]
        Global.createJSONDetails("burnedData", jsonData: newDic)
    }
    
    class func getBurnedArray() -> [BurnedClass] {
        
        var dataArray : [BurnedClass] = []
        
        if let dic = Global.getFileDetails("burnedData") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = BurnedClass.initWithArray(array)
            }
        }
        return dataArray
    }
    
    class func deleteRecord(_ object : BurnedClass) {
        
        let dataArray = NSArray()
        var burnedDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("burnedData") {
            burnedDic = dic
        }
        
        var burnedArray = NSMutableArray()
        
        if let array = burnedDic.value(forKey: "data") as? NSArray {
            burnedArray = NSMutableArray(array: array)
        }
        
        let filterArray = burnedArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "burnedId") as? String {
                    if str == object.burnedId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            burnedArray.remove(filterArray[0])
        }

        let newDic : NSDictionary = [
            "data":burnedArray
        ]
        Global.createJSONDetails("burnedData", jsonData: newDic)
    }
}
