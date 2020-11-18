//
//  AnyObject+Extension.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 8/14/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//


import Foundation

class AnyObjectRef {
    
    let value: AnyObject?
    
    init(_ value: AnyObject?) {
        self.value = value
    }
    
    @objc func stringValue() -> String {
        
        if let value = value {
            if let val = value as? String {
                return val
            }
            if value.isKind(of: NSNull.self) == true {
                return ""
            }
            if value.isKind(of: NSNumber.self) == true {
                return String(format: "%@", arguments: [value as! NSNumber])
            }
        }
        return ""
    }
    
    @objc func intValue() -> Int {
        
        if let value = value {
            if let val = value as? Int {
                return val
            }
            if value.isKind(of: NSNull.self) == true {
                return 0
            }
            if value.isKind(of: NSNumber.self) == true {
                return NSInteger(truncating: value as! NSNumber)
            }
            if value.isKind(of: NSString.self) {
                if let str = value as? String {
                    if str == "" {
                        return 0
                    }
                    if let val = Int(str) {
                        return val
                    }
                    if let value1 = Float(str) {
                        return Int(value1)
                    }
                }
            }
        }
        return 0
    }
    
    @objc func floatValue() -> Float {
        
        if let value = value {
            if let val = value as? Float {
                return val
            }
            if value.isKind(of: NSNull.self) == true {
                return 0
            }
            if value.isKind(of: NSNumber.self) == true {
                return Float(truncating: value as! NSNumber)
            }
            if let str = value as? String {
                if str == "" {
                    return 0
                }
                if let val = Float(str) {
                    return val
                }
            }
        }
        return 0
    }
    
    @objc func doubleValue() -> Double {
        
        if let value = value {
            if let val = value as? Double {
                return val
            }
            if value.isKind(of: NSNull.self) == true {
                return 0
            }
            if value.isKind(of: NSNumber.self) == true {
                return Double(truncating: value as! NSNumber)
            }
            if let str = value as? String {
                if str == "" {
                    return 0
                }
                if let val = Double(str) {
                    return val
                }
            }
        }
        return 0
    }
    
    @objc func boolValue() -> Bool {
        
        if let value = value {
            if let val = value as? Bool {
                return val
            }
            if value.isKind(of: NSNull.self) == true {
                return false
            }
            if value.isKind(of: NSNumber.self) {
                
                if let val = value as? Decimal {
                    if val == 1 {
                        return true
                    }
                    return false
                }
            }
            if value.isKind(of: NSString.self) {
                if let str = value as? String {
                    
                    if str == "1" {
                        return true
                    }
                    return false
                }
            }
        }
        return false
    }
    
    @objc func numberValue() -> NSNumber {
        
        if let value = value {
            if value.isKind(of: NSNull.self) == false {
                return value as! NSNumber
            }
        }
        return 0
    }
}
