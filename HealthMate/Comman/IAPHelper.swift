//
//  IAPHelper.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 20/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class IAPHelper: NSObject {
    
    class func subscribePayment(productId : String, completionHandler:@escaping (Bool)->())->(){
        
        let appleValidator = AppleReceiptValidator(service: AppleReceiptValidator.VerifyReceiptURLType.production, sharedSecret: Constants.SHARED_SECRET_KEY)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { (result) in
            
            if case .success(let receipt) = result {
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: SubscriptionType.autoRenewable, productId: productId, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let recipetItem):
                    print("productId = \(productId) Product is valid until expiryDate = \(expiryDate)")
                    print("recipetItem = ", recipetItem)
                    completionHandler(true)
                case .expired(let expiryDate, let recipetItem):
                    print("productId = \(productId) Product is expired since expiryDate = \(expiryDate)")
                    print("recipetItem = ", recipetItem)
                    completionHandler(false)
                case .notPurchased:
                    print("This product has never been purchased")
                    completionHandler(false)
                }
            }
            else {
                // receipt verification error
                completionHandler(false)
            }
        }
    }
    
}
