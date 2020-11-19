//
//  WorkoutClass.swift
//  HealthMate
//
//  Created by AppDeveloper on 11/11/20.
//

import UIKit

class WorkoutClass: NSObject {
    
    var workoutId : String = ""
    var title : String = ""
    var workoutDescription : String = ""
    var duration : String = ""
    var image : String = ""
    var level : String = ""
    var calorie : Float = 0
    var difficulty : String = ""
    
    var workoutExerciseArray : [WorkoutExerciseClass] = []
    
    class func initWithData(_ data : NSDictionary) -> WorkoutClass {
        
        let object = WorkoutClass()
        
        object.workoutId = AnyObjectRef(data.value(forKey: "id") as AnyObject).stringValue()
        object.title = AnyObjectRef(data.value(forKey: "title") as AnyObject).stringValue()
        object.workoutDescription = AnyObjectRef(data.value(forKey: "description") as AnyObject).stringValue()
        object.image = AnyObjectRef(data.value(forKey: "image") as AnyObject).stringValue()
        object.level = AnyObjectRef(data.value(forKey: "level") as AnyObject).stringValue()
//        object.calorie = AnyObjectRef(data.value(forKey: "cal") as AnyObject).floatValue()
        object.duration = AnyObjectRef(data.value(forKey: "duration") as AnyObject).stringValue()
        object.difficulty = AnyObjectRef(data.value(forKey: "difficulty") as AnyObject).stringValue()
        if let array = data.value(forKey: "workoutExercise") as? NSArray {
            object.workoutExerciseArray = WorkoutExerciseClass.initWithArray(array)
        }
        for obj in object.workoutExerciseArray {
            object.calorie += obj.calorie
        }
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [WorkoutClass] {
        
        var array : [WorkoutClass] = []
        
        for i in 0..<data.count {
            array.append(WorkoutClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class WorkoutExerciseClass: NSObject {
    
    var workoutId : String = ""
    var title : String = ""
    var videoURL : String = ""
    var duration : Int = 0
    var calorie : Float = 0
    var met : Float = 0
    var isDownloaded : Bool = false
    var filePathURL : URL!
    
    class func initWithData(_ data : NSDictionary) -> WorkoutExerciseClass {
        
        let object = WorkoutExerciseClass()
        
        object.workoutId = AnyObjectRef(data.value(forKey: "id") as AnyObject).stringValue()
        object.title = AnyObjectRef(data.value(forKey: "title") as AnyObject).stringValue()
        object.videoURL = AnyObjectRef(data.value(forKey: "videoUrl") as AnyObject).stringValue()
        object.duration = AnyObjectRef(data.value(forKey: "duration") as AnyObject).intValue()
        object.met = AnyObjectRef(data.value(forKey: "met") as AnyObject).floatValue()
        
        let caloriesBurnPerHour = UserClass.getWeight() * object.met
        let second = Float(object.duration) / Float(3600)
        object.calorie = Float(Int(ceilf(caloriesBurnPerHour * second)))
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [WorkoutExerciseClass] {
        
        var array : [WorkoutExerciseClass] = []
        
        for i in 0..<data.count {
            array.append(WorkoutExerciseClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class CalorieCalculatorClass: NSObject {

    var action : String = ""
    var calories : Float = 0
    var value : Float = 0
    var unit : String = ""

    
    class func initWithData(_ data : NSDictionary) -> CalorieCalculatorClass {
        
        let object = CalorieCalculatorClass()
        
        object.action = AnyObjectRef(data.value(forKey: "action") as AnyObject).stringValue()
        object.calories = AnyObjectRef(data.value(forKey: "calories") as AnyObject).floatValue()
        object.value = AnyObjectRef(data.value(forKey: "value") as AnyObject).floatValue()
        object.unit = AnyObjectRef(data.value(forKey: "unit") as AnyObject).stringValue()

        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [CalorieCalculatorClass] {
        
        var array : [CalorieCalculatorClass] = []
        
        for i in 0..<data.count {
            array.append(CalorieCalculatorClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class RecipeClass: NSObject {
    
    var recipeId : String = ""
    var title : String = ""
    var image : String = ""
    var calorie : Float = 0
    var fat : Float = 0
    var carbs : Float = 0
    var protein : Float = 0
    var preperationTime : Int = 0
    var cookTime : Int = 0
    var totalTime : Int = 0
    var serve : Int = 0
    var ingredientArray : [IngredientClass] = []
    var directionsArray : [String] = []
    var recipeDescription : String = ""
    var meals : [String] = []
    
    class func initWithData(_ data : NSDictionary) -> RecipeClass {
        
        let object = RecipeClass()
        
        object.recipeId = AnyObjectRef(data.value(forKey: "id") as AnyObject).stringValue()
        object.title = AnyObjectRef(data.value(forKey: "title") as AnyObject).stringValue()
        object.image = AnyObjectRef(data.value(forKey: "image") as AnyObject).stringValue()
        object.recipeDescription = AnyObjectRef(data.value(forKey: "description") as AnyObject).stringValue()
        object.calorie = AnyObjectRef(data.value(forKey: "calorie") as AnyObject).floatValue()
        object.fat = AnyObjectRef(data.value(forKey: "fat") as AnyObject).floatValue()
        object.protein = AnyObjectRef(data.value(forKey: "protein") as AnyObject).floatValue()
        object.carbs = AnyObjectRef(data.value(forKey: "carbs") as AnyObject).floatValue()
        object.preperationTime = AnyObjectRef(data.value(forKey: "preperationTime") as AnyObject).intValue()
        object.cookTime = AnyObjectRef(data.value(forKey: "cookTime") as AnyObject).intValue()
        object.serve = AnyObjectRef(data.value(forKey: "serve") as AnyObject).intValue()
        if let array = data.value(forKey: "directions") as? [String] {
            object.directionsArray = array
        }
        if let array = data.value(forKey: "ingredients") as? NSArray {
            object.ingredientArray = IngredientClass.initWithArray(array)
        }
        if let array = data.value(forKey: "meals") as? [String] {
            object.meals = array
        }
        object.totalTime = object.preperationTime + object.cookTime
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [RecipeClass] {
        
        var array : [RecipeClass] = []
        
        for i in 0..<data.count {
            array.append(RecipeClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class IngredientClass: NSObject {
    
    var ingredientId : String = ""
    var title : String = ""
    
    class func initWithData(_ data : NSDictionary) -> IngredientClass {
        
        let object = IngredientClass()
        
        object.ingredientId = AnyObjectRef(data.value(forKey: "id") as AnyObject).stringValue()
        object.title = AnyObjectRef(data.value(forKey: "title") as AnyObject).stringValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [IngredientClass] {
        
        var array : [IngredientClass] = []
        
        for i in 0..<data.count {
            array.append(IngredientClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class ProgressClass: NSObject {
    
    var dateString : String = ""
    var date : Date = Date()
    var value : Float = 0
}
class ExerciseCategoryClass: NSObject {
    
    var mets : Float = 0
    var serious : Float = 0
    var category : String = ""
    var activity : String = ""
    
    class func initWithData(_ data : NSDictionary) -> ExerciseCategoryClass {
        
        let object = ExerciseCategoryClass()
        
        object.mets = AnyObjectRef(data.value(forKey: "mets") as AnyObject).floatValue()
        object.serious = AnyObjectRef(data.value(forKey: "serious") as AnyObject).floatValue()
        object.category = AnyObjectRef(data.value(forKey: "category") as AnyObject).stringValue()
        object.activity = AnyObjectRef(data.value(forKey: "activity") as AnyObject).stringValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [ExerciseCategoryClass] {
        
        var array : [ExerciseCategoryClass] = []
        
        for i in 0..<data.count {
            array.append(ExerciseCategoryClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
}
class ActivityClass: NSObject {
    
    var durationMin : Int = 0
    var mets : Float = 0
    var burnedCalories : Float = 0
    var compendiumCode : Int = 0
    var name : String = ""
    var tagId : Int = 0
    
    class func initWithData(_ data : NSDictionary) -> ActivityClass {
        
        let object = ActivityClass()
        
        object.durationMin = AnyObjectRef(data.value(forKey: "durationMin") as AnyObject).intValue()
        object.mets = AnyObjectRef(data.value(forKey: "mets") as AnyObject).floatValue()
        object.burnedCalories = AnyObjectRef(data.value(forKey: "burnedCalories") as AnyObject).floatValue()
        object.compendiumCode = AnyObjectRef(data.value(forKey: "compendiumCode") as AnyObject).intValue()
        object.name = AnyObjectRef(data.value(forKey: "name") as AnyObject).stringValue()
        object.tagId = AnyObjectRef(data.value(forKey: "tagId") as AnyObject).intValue()
        return object
    }
    
    class func initWithArray(_ data : NSArray) -> [ActivityClass] {
        
        var array : [ActivityClass] = []
        
        for i in 0..<data.count {
            array.append(ActivityClass.initWithData(data.object(at: i) as! NSDictionary))
        }
        return array
    }
    
    class func getActivityDictionary(_ object : ActivityClass) -> NSMutableDictionary {
        
        let dic : NSDictionary = [
            "durationMin":object.durationMin,
            "mets":object.mets,
            "burnedCalories":object.burnedCalories,
            "compendiumCode":object.compendiumCode,
            "name":object.name,
            "tagId":object.tagId
        ]
        return NSMutableDictionary(dictionary: dic)
    }
}
