//
//  ExerciseClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 5/11/20.
//

import UIKit

class ExerciseClass: NSObject {

    var exerciseId : String = ""
    var name : String = ""
    var calorie : Float = 0
    var isCustomExercise : Bool = false
    var isWorkout : Bool = false
    var isSearchExercise : Bool = false
    var orderNo : Int = 0
    
    class func initWithData(_ data : NSDictionary) -> ExerciseClass {
        
        let object = ExerciseClass()
        
        object.exerciseId = AnyObjectRef(data.value(forKey: "exerciseId") as AnyObject).stringValue()
        object.name = AnyObjectRef(data.value(forKey: "name") as AnyObject).stringValue()
        object.calorie = AnyObjectRef(data.value(forKey: "calorie") as AnyObject).floatValue()
        object.isCustomExercise = AnyObjectRef(data.value(forKey: "isCustomExercise") as AnyObject).boolValue()
        object.isSearchExercise = AnyObjectRef(data.value(forKey: "isSearchExercise") as AnyObject).boolValue()
        object.isWorkout = AnyObjectRef(data.value(forKey: "isWorkout") as AnyObject).boolValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [ExerciseClass] {
        
        var array : [ExerciseClass] = []
        
        for i in 0..<data.count {
            array.append(ExerciseClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func getExerciseDictionary(_ object : ExerciseClass) -> NSMutableDictionary {
        
        let dic : NSDictionary = [
            "exerciseId":object.exerciseId,
            "name":object.name,
            "calorie":object.calorie,
            "isCustomExercise":object.isCustomExercise,
            "isSearchExercise":object.isSearchExercise,
            "isWorkout":object.isWorkout
        ]
        return NSMutableDictionary(dictionary: dic)
    }
    
    class func updateRecord(_ object : ExerciseClass) {
        
        let dataArray = NSArray()
        var exerciseDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("exercise") {
            exerciseDic = dic
        }
        
        var exerciseArray = NSMutableArray()
        
        if let array = exerciseDic.value(forKey: "data") as? NSArray {
            exerciseArray = NSMutableArray(array: array)
        }
        let dic = ExerciseClass.getExerciseDictionary(object)
        dic.setValue(exerciseArray.count, forKey: "orderNo")
        
        let filterArray = exerciseArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "exerciseId") as? String {
                    if str == object.exerciseId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            exerciseArray.remove(filterArray[0])
        }
        
        exerciseArray.add(dic)
        
        let newDic : NSDictionary = [
            "data":exerciseArray
        ]
        Global.createJSONDetails("exercise", jsonData: newDic)
    }
    
    class func deleteRecord(_ object : ExerciseClass) {
        
        let dataArray = NSArray()
        var exerciseDic : NSDictionary = [
            "data":dataArray
        ]
        
        if let dic = Global.getFileDetails("exercise") {
            exerciseDic = dic
        }
        
        var exerciseArray = NSMutableArray()
        
        if let array = exerciseDic.value(forKey: "data") as? NSArray {
            exerciseArray = NSMutableArray(array: array)
        }
        
        let filterArray = exerciseArray.filter { (obj) -> Bool in
            if let dic1 = obj as? NSDictionary {
                if let str = dic1.value(forKey: "exerciseId") as? String {
                    if str == object.exerciseId {
                        return true
                    }
                }
            }
            return false
        }
        
        if filterArray.count > 0 {
            exerciseArray.remove(filterArray[0])
        }

        let newDic : NSDictionary = [
            "data":exerciseArray
        ]
        Global.createJSONDetails("exercise", jsonData: newDic)
    }
    
    class func getExerciseArray() -> [ExerciseClass] {
        
        var dataArray : [ExerciseClass] = []
        
        if let dic = Global.getFileDetails("exercise") {
            
            if let array = dic.value(forKey: "data") as? NSArray {
                dataArray = ExerciseClass.initWithArray(array)
            }
        }
        return dataArray
    }
    
    class func getCustomExerciseArray() -> [ExerciseClass] {
        
        var dataArray : [ExerciseClass] = []
        
        if let dic = Global.getFileDetails("exercise") {
            
                        if let array = dic.value(forKey: "data") as? NSArray {
                let filterArray = ExerciseClass.initWithArray(array)
                dataArray = filterArray.filter { (obj) -> Bool in
                    return obj.isCustomExercise
                }
            }
        }
        return dataArray
    }
}
