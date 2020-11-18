//
//  APIHelperClass.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 14/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit
import AFNetworking

class APIHelperClass: NSObject {
    
    static let baseURL : String                     = "https://health-mate-api.herokuapp.com/"
    
    static let calorieCalculator : String           = "calorie-calculator"
    static let workouts : String                    = "workouts"
    static let recipes : String                     = "recipes"
    static let activities : String                  = "activities"
    static let activitiesQuery : String             = "activities/query"
    static let config : String                      = "config"
    
    var responseData : NSMutableData!
    var objectAFJSONResponseSerializer = AFJSONResponseSerializer(readingOptions: .allowFragments)
    
    class var sharedInstance : APIHelperClass {
        struct Static {
            static let instance : APIHelperClass = APIHelperClass()
        }
        return Static.instance
    }
    
    func getRequest(_ getURL : String!, parameters:NSMutableDictionary!, completionHandler:@escaping (NSDictionary?,NSError?, Int)->())->(){
        
        let manager : AFHTTPSessionManager = AFHTTPSessionManager()
        manager.responseSerializer = objectAFJSONResponseSerializer
        let serializer : AFJSONRequestSerializer = AFJSONRequestSerializer ()
        serializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        serializer.setValue("application/json", forHTTPHeaderField: "Accept")
        serializer.setValue(Constants.ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
        serializer.setValue(Global.getLanguageCode(), forHTTPHeaderField: "accept-language")
        manager.requestSerializer = serializer
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
        manager.requestSerializer.timeoutInterval = 120
        let url : String = APIHelperClass.baseURL + getURL
        
        print("================")
        print("URL : \(url)")
        print("Parameters : \(parameters ?? NSDictionary())")
        
        manager.get(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, parameters: parameters, headers: nil, progress: nil, success: { (operation, responseObject) in
            
            var reponseDic : NSDictionary!
            if let responseObject1 = responseObject {

                if let JSONDictionary :NSDictionary = responseObject1 as? NSDictionary {
                    reponseDic = JSONDictionary
                }
                else if let JSONArray :NSArray = responseObject1 as? NSArray {
                    reponseDic = ["data" : JSONArray]
                }
                else if let JSONString : String = responseObject as? String {
                    
                    if let JSONDictionary : NSDictionary = Global.convertToDictionary(text: JSONString) as NSDictionary? {
                        reponseDic = JSONDictionary
                    }
                }
            }

            print("Response : \(reponseDic ?? NSDictionary())")
            print("================")
            
            completionHandler(reponseDic,nil, 200)
            
        }) { (operation, error) in
            print("\(error.localizedDescription)")
            print("================")
            var statusCode : Int = 400
            
            if let response1 = operation?.response as? HTTPURLResponse {
                statusCode = response1.statusCode
            }
            completionHandler(nil,error as NSError?, statusCode)
        }
    }
    
    func postRequest(_ postURL : String!, parameters:NSMutableDictionary!, completionHandler:@escaping (NSDictionary?,NSError?, Int)->())->(){
        
        let manager : AFHTTPSessionManager = AFHTTPSessionManager()
        manager.responseSerializer = objectAFJSONResponseSerializer
        let serializer : AFJSONRequestSerializer = AFJSONRequestSerializer ()
        serializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        serializer.setValue("application/json", forHTTPHeaderField: "Accept")
        serializer.setValue(Constants.ACCESS_TOKEN, forHTTPHeaderField: "Authorization")
        serializer.setValue(Global.getLanguageCode(), forHTTPHeaderField: "accept-language")
        manager.requestSerializer = serializer
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
        
        
        let url : String = APIHelperClass.baseURL + postURL
        print("================")
        print("URL : \(url)")
        print("Parameters : \(parameters ?? NSDictionary())")
        
        manager.post(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, parameters: parameters, headers: nil, progress: nil, success: { (operation, responseObject) in
            
            
            var reponseDic : NSDictionary!
            
            if let responseObject1 = responseObject {

                if let JSONDictionary :NSDictionary = responseObject1 as? NSDictionary {
                    reponseDic = JSONDictionary
                }
                else if let JSONArray :NSArray = responseObject1 as? NSArray {
                    reponseDic = ["data" : JSONArray]
                }
                else if let JSONString : String = responseObject as? String {
                    
                    if let JSONDictionary : NSDictionary = Global.convertToDictionary(text: JSONString) as NSDictionary? {
                        reponseDic = JSONDictionary
                    }
                }
            }
            print("Response : \(reponseDic ?? NSDictionary())")
            print("================")
            completionHandler(reponseDic,nil, 200)
            
        }) { (operation, error) in
            print("\(error.localizedDescription)")
            print("================")
            var statusCode : Int = 400
            
            if let response1 = operation?.response as? HTTPURLResponse {
                statusCode = response1.statusCode
            }
            completionHandler(nil,error as NSError?, statusCode)
        }
    }
}
