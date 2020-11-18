//
//  String+Extension.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 8/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func toLocalize() -> String {
        
        let key = self
        let languageCode = Global.getLanguageCode()
        let bundlePath : String = Bundle.main.path(forResource: languageCode, ofType: "lproj")!
        let languageBundle : Bundle = Bundle(path: bundlePath)!
        var translatedString = languageBundle.localizedString(forKey: key as String, value: "", table: nil)
        
        if translatedString.count < 1 {
            translatedString = NSLocalizedString(key, tableName: nil, bundle: Bundle.main , value: key, comment: key)
        }
        return translatedString
    }
    
    var letters: String {
        return self.chopPrefix()
//        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
//        return self.filter {okayChars.contains($0) }
//        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
}
extension String {

    func chopPrefix(_ count: Int = 1) -> String {
        if count >= 0 && count <= self.count {
            let indexStartOfText = self.index(self.startIndex, offsetBy: count)
            return String(self[indexStartOfText...])
        }
        return ""
    }

    func chopSuffix(_ count: Int = 1) -> String {
        if count >= 0 && count <= self.count {
            let indexEndOfText = self.index(self.endIndex, offsetBy: -count)
            return String(self[..<indexEndOfText])
        }
        return ""
    }
}
extension Float {
    
    func toString() -> String {
        
        let isInteger = floor(self) == self
        if isInteger {
            return String(format: "%.0f", self)
        }
        return String(format: "%.2f", self)
    }
    func toRound() -> String {
        
        return String(format: "%.0f", self)
    }
}
extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}
extension Date {
    
    func isToday() -> Bool {
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd-MM-yyyy"
        if formatter1.string(from: Date()) == formatter1.string(from: self) {
            return true
        }
        return false
    }
    
    func getDaysInMonth() -> Int{
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var startOfYear: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.month = 12
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
