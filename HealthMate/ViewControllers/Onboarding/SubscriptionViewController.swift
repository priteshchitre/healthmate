//
//  SubscriptionViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit
import SwiftyStoreKit
import SafariServices

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var starViewTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privacyLabel: TapLabel!
    @IBOutlet weak var freeView: UIView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var trialSwitch: UISwitch!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var trialTitleLabel: UILabel!
    @IBOutlet weak var trialSubTitleLabel: UILabel!
    
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var yearlyView: UIView!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var yearlyPriceLabel: UILabel!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var trialContentView: UIView!
    
    @IBOutlet weak var monthlyTextLabel: UILabel!
    @IBOutlet weak var yearlyTextLabel: UILabel!
    @IBOutlet weak var weeklyTextLabel: UILabel!
    @IBOutlet weak var weeklyView: UIView!
    
    @IBOutlet weak var textLabelTop: NSLayoutConstraint!
    @IBOutlet weak var textLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var weeklyFreeLabel: UILabel!
    
    var isTrial : Bool = true
    var selectedPlan = PLANS.WEEKLY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_SUBSCRIPTION), object: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func initLocal() {

        self.monthlyView.layer.addCustomShadow()
        self.weeklyView.layer.addCustomShadow()
        self.yearlyView.layer.addCustomShadow()
        
        self.weeklyView.layer.borderWidth = 1
        self.weeklyView.layer.borderColor = Color.appOrange.cgColor

        self.monthlyView.layer.borderWidth = 1
        self.monthlyView.layer.borderColor = Color.appOrange.cgColor
        
        self.yearlyView.layer.borderWidth = 1
        self.yearlyView.layer.borderColor = Color.appOrange.cgColor
        
        self.weeklyTextLabel.text = "weekly".toLocalize().capitalized
        self.monthlyTextLabel.text = "monthly".toLocalize().capitalized
        self.yearlyTextLabel.text = "yearly".toLocalize().capitalized
        
        self.popularLabel.text = "POPULAR".toLocalize()
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        self.trialLabel.text = "Not_sure_yet_Enable_free_trial".toLocalize()
        self.trialTitleLabel.text = "Trial_period".toLocalize()
        self.trialSubTitleLabel.text = "Turn_off_to_discover_other_plans".toLocalize()
        
        self.titleLabel.text = "Join_Millions_of_Happy_Users".toLocalize()
        self.privacyLabel.text = "\("EULA".toLocalize())  |  \("Privacy_Policy".toLocalize())  |  \("Restore".toLocalize())"
        
        self.highlightLinksWithIndex()
        self.starLabel.text = "\u{2605} \u{2605} \u{2605} \u{2605} \u{2605}"
        let str1 = "\u{2713} \("Free_daily_calorie_counter".toLocalize())\n"
        let attr1 = NSMutableAttributedString(string: str1)
        let matchRange1 = (str1 as NSString).range(of: "\u{2713}")
        attr1.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.roundButtonColor , range: matchRange1)
        attr1.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20) , range: matchRange1)
        
        let str2 = "\u{2713} \("Hyper_personalized_meal_plan".toLocalize())\n"
        let attr2 = NSMutableAttributedString(string: str2)
        let matchRange2 = (str2 as NSString).range(of: "\u{2713}")
        attr2.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.roundButtonColor , range: matchRange2)
        attr2.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20) , range: matchRange2)
        
        let str3 = "\u{2713} \("Advanced_workout_programs".toLocalize())\n"
        let attr3 = NSMutableAttributedString(string: str3)
        let matchRange3 = (str3 as NSString).range(of: "\u{2713}")
        attr3.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.roundButtonColor , range: matchRange3)
        attr3.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20) , range: matchRange3)
        
        let str4 = "\u{2713} \("Based_on_AI_data".toLocalize())\n"
        let attr4 = NSMutableAttributedString(string: str4)
        let matchRange4 = (str4 as NSString).range(of: "\u{2713}")
        attr4.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.roundButtonColor , range: matchRange4)
        attr4.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20) , range: matchRange4)
        
        
        self.textLabel.textColor = UIColor.black
        let attributedString = NSMutableAttributedString()
        attributedString.append(attr1)
        attributedString.append(attr2)
        attributedString.append(attr3)
        attributedString.append(attr4)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        if UIScreen.main.nativeBounds.height <= 1136 {
            paragraphStyle.lineSpacing = 2
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.textLabel.attributedText = attributedString
        
        
    }
    
    func initView() {
        
        self.initLocal()

        UserClass.setSubscribeScreen(true)
        self.setNavigationBar()
        self.setBackBarButton(true)
        
        self.popularLabel.layer.cornerRadius = 8
        
        self.purchaseView.isHidden = true
        self.freeView.isHidden = false
        self.trialLabel.isHidden = true
        self.trialTitleLabel.isHidden = false
        self.trialSubTitleLabel.isHidden = false
        
        self.trialSwitch.isOn = true
        self.privacyLabel.delegate = self
        
//        self.trialContentView.layer.borderWidth = 1
//        self.trialContentView.layer.borderColor = UIColor(red: 32, green: 33, blue: 34).cgColor
        self.updatePlanButton()
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            self.titleLabelTop.constant = 0
            self.starViewTop.constant = -10
            self.titleLabelBottom.constant = 0
            self.titleLabelHeight.constant = 25
            self.textLabelTop.constant = 8
            self.textLabelBottom.constant = 8
        }
        
        if UserClass.getSubscriptionConfig() == 1 {
            self.weeklyFreeLabel.isHidden = true
            self.weeklyView.isHidden = false
        }
        else {
            self.weeklyFreeLabel.isHidden = false
            self.weeklyView.isHidden = true
        }
    }
    
    func initElements() {
        
        Global.showProgressHud()
        
        SwiftyStoreKit.retrieveProductsInfo([PLANS.WEEKLY.rawValue, PLANS.MONTHLY.rawValue, PLANS.YEARLY.rawValue, PLANS.WEEKLY_3DAYS_TRIAL.rawValue]) { result in
            
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            for product in result.retrievedProducts {
                
                if product.productIdentifier == PLANS.WEEKLY.rawValue {
                    if let price = product.localizedPrice {
                        if UserClass.getWeeklySubscriptionId() != PLANS.WEEKLY_3DAYS_TRIAL.rawValue {
                            self.freeLabel.text = "\("First_7_days_free_then".toLocalize()) \(price)/\("week".toLocalize()). \("Cancel_anytime".toLocalize())"
                            self.weeklyFreeLabel.text = "\("First_7_days_free_then".toLocalize()) \(price)/\("week".toLocalize()). \("No_commitment_Cancel_anytime".toLocalize())"
                        }
                    }
                }
                else if product.productIdentifier == PLANS.WEEKLY_3DAYS_TRIAL.rawValue {
                    if let price = product.localizedPrice {
                        if UserClass.getWeeklySubscriptionId() == PLANS.WEEKLY_3DAYS_TRIAL.rawValue {
                            self.freeLabel.text = "\("First_7_days_free_then".toLocalize()) \(price)/\("week".toLocalize()). \("Cancel_anytime".toLocalize())"
                            self.weeklyFreeLabel.text = "\("First_7_days_free_then".toLocalize()) \(price)/\("week".toLocalize()). \("No_commitment_Cancel_anytime".toLocalize())"
                            self.freeLabel.text = self.freeLabel.text?.replacingOccurrences(of: "7", with: "\(UserClass.getDaysFree())")
                            self.weeklyFreeLabel.text = self.freeLabel.text?.replacingOccurrences(of: "7", with: "\(UserClass.getDaysFree())")
                        }
                    }
                }
                else if product.productIdentifier == PLANS.MONTHLY.rawValue {
                    if let price = product.localizedPrice {
                        self.monthlyPriceLabel.text = "\(price)/\("month".toLocalize()). \("Cancel_anytime".toLocalize())"
                    }
                }
                else if product.productIdentifier == PLANS.YEARLY.rawValue {
                    if let price = product.localizedPrice {
                        self.yearlyPriceLabel.text = "\(price)/\("year".toLocalize()). \("Cancel_anytime".toLocalize())"
                    }
                }
            }
        }
    }
    
    func highlightLinksWithIndex() {
        
        let attributedString: NSMutableAttributedString = self.privacyLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        let linkStringArray : [String] = ["EULA".toLocalize(), "\("Privacy_Policy".toLocalize())", "Restore".toLocalize()]
        for strMatch: String in linkStringArray {
            let longString = self.privacyLabel.text! as NSString
            let matchRange = (longString as NSString).range(of: strMatch)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: matchRange)
        }
        self.privacyLabel.attributedText = attributedString
    }
    
    func updatePlanButton()  {

        self.monthlyView.backgroundColor = UIColor.white
        self.yearlyView.backgroundColor = UIColor.white
        
        
        if self.selectedPlan == .MONTHLY {
            
            self.monthlyView.backgroundColor = Color.appOrange
            self.yearlyView.backgroundColor = UIColor.white
        }
        else if self.selectedPlan == .YEARLY {
            self.yearlyView.backgroundColor = Color.appOrange
            self.monthlyView.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func onTrialSwitchTap(_ sender: Any) {
        
        if self.trialSwitch.isOn {
            self.purchaseView.isHidden = true
            self.freeView.isHidden = false
            self.trialLabel.isHidden = true
            self.trialTitleLabel.isHidden = false
            self.trialSubTitleLabel.isHidden = false
            self.selectedPlan = .WEEKLY
        }
        else {
            self.purchaseView.isHidden = false
            self.freeView.isHidden = true
            self.trialLabel.isHidden = false
            self.trialTitleLabel.isHidden = true
            self.trialSubTitleLabel.isHidden = true
            self.selectedPlan = .YEARLY
            self.updatePlanButton()
        }
    }
    
    @IBAction func onMonthlyButtonTap(_ sender: Any) {
        
        self.selectedPlan = .MONTHLY
        self.updatePlanButton()
    }
    
    @IBAction func onYealyButtonTap(_ sender: Any) {
        
        self.selectedPlan = .YEARLY
        self.updatePlanButton()
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
        if self.selectedPlan == .WEEKLY {

            if UserClass.getWeeklySubscriptionId() == PLANS.WEEKLY_3DAYS_TRIAL.rawValue {
                self.selectedPlan = .WEEKLY_3DAYS_TRIAL
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            Global.openDashboard()
//        }
        
        DispatchQueue.main.async {
            self.purchase()
        }
    }
    
    func openPrivacyPage() {
        
        let url = URL(string: Constants.PRIVACY_POLICY)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    
    func openEULA() {
        
        let url = URL(string: Constants.PRIVACY_POLICY)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    
    func purchase() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        Global.showProgressHud()
        SwiftyStoreKit.purchaseProduct(self.selectedPlan.rawValue, atomically: true) { result in
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                TenjinSDK.sendEvent(withName: self.selectedPlan.rawValue)
                
                if self.selectedPlan == .MONTHLY || self.selectedPlan == .YEARLY {
                    
                    if let transaction = purchase.transaction as? SKPaymentTransaction {
                        
                        if let receiptDataURL = Bundle.main.appStoreReceiptURL {
                            
                            if let data = try? Data(contentsOf: receiptDataURL) {
                                TenjinSDK.transaction(transaction, andReceipt: data)
                            }
                        }
                    }
                }
                else {
                    TenjinSDK.sendEvent(withName: "start_trial")
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    // ========== Manage Restore ==============
    
    func openRestore() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        Global.showProgressHud()
        
        SwiftyStoreKit.restorePurchases { (results) in
            
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                print("purchase = ", purchase.productId)
            }
            self.restorePurchasesResponse(results)
        }
    }
    
    func restorePurchasesResponse(_ results: RestoreResults) {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            self.restoreProductsCompleted()
        }
        else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            
            var restoreProducts : [String] = []
            
            for purchase in results.restoredPurchases {
                
                if purchase.productId == PLANS.WEEKLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.WEEKLY.rawValue)" {
                    if !restoreProducts.contains(PLANS.WEEKLY.rawValue) {
                        restoreProducts.append(PLANS.WEEKLY.rawValue)
                    }
                }
                else if purchase.productId == PLANS.WEEKLY_3DAYS_TRIAL.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.WEEKLY_3DAYS_TRIAL.rawValue)" {
                    if !restoreProducts.contains(PLANS.WEEKLY_3DAYS_TRIAL.rawValue) {
                        restoreProducts.append(PLANS.WEEKLY_3DAYS_TRIAL.rawValue)
                    }
                }
                else if purchase.productId == PLANS.MONTHLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.MONTHLY.rawValue)" {
                    if !restoreProducts.contains(PLANS.MONTHLY.rawValue) {
                        restoreProducts.append(PLANS.MONTHLY.rawValue)
                    }
                }
                else if purchase.productId == PLANS.YEARLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.YEARLY.rawValue)" {
                    if !restoreProducts.contains(PLANS.YEARLY.rawValue) {
                        restoreProducts.append(PLANS.YEARLY.rawValue)
                    }
                }
            }
            self.getRestoreProducts(restoreProducts)
        }
        else {
            print("Nothing to Restore")
            self.restoreProductsCompleted()
        }
    }
    
    func getRestoreProducts(_ productsId : [String]) {
        
        if productsId.count > 0 {
            self.restoreProductsRecursive(productsIdArray: productsId, index: 0)
        }
        else {
            self.restoreProductsCompleted()
        }
    }
    
    func restoreProductsRecursive(productsIdArray : [String], index : Int) {
        
        IAPHelper.subscribePayment(productId: productsIdArray[index]) { (isPurchased) in
            
            if productsIdArray[index] == PLANS.WEEKLY.rawValue {
                UserClass.setWeeklySubscription(isPurchased)
            }
            else if productsIdArray[index] == PLANS.WEEKLY_3DAYS_TRIAL.rawValue {
                UserClass.setWeekly3DaysSubscription(isPurchased)
            }
            else if productsIdArray[index] == PLANS.MONTHLY.rawValue {
                UserClass.setMonthlySubscription(isPurchased)
            }
            else if productsIdArray[index] == PLANS.YEARLY.rawValue {
                UserClass.setYearlySubscription(isPurchased)
            }
            
            if !isPurchased {
                let index1 = index + 1
                if productsIdArray.count > index1 {
                    self.restoreProductsRecursive(productsIdArray: productsIdArray, index: index1)
                }
                else {
                    self.restoreProductsCompleted()
                }
            }
            else {
                self.restoreProductsCompleted()
            }
        }
    }
    
    func restoreProductsCompleted() {
        
        DispatchQueue.main.async {
            Global.hideProgressHud()
        }
        
        if UserClass.isUserSubscribe() {
            
            let alert = UIAlertController(title: "Welcome_Back".toLocalize(), message: "Your_subscription_has_been_restored_Enjoy_HealthMate_app".toLocalize(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
                
                DispatchQueue.main.async {
                    Global.openDashboard()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "No_purchase_found".toLocalize(), message: "Please_start_a_new_subscription_to_enjoy_app".toLocalize(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // ========== End Manage Restore ==============
    
    func purchaseSuccess() {
        
        if UserClass.isUserSubscribe() {

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                Global.openDashboard()
            }
        }
    }
}
extension SubscriptionViewController : TapLabelDelegate {
    
    func label(_ label: TapLabel!, didCancel touch: UITouch!) -> Bool {
        return true
    }
    
    func label(_ label: TapLabel!, didEnd touch: UITouch!, onCharacterAt charIndex: CFIndex) -> Bool {
        
        let longString = self.privacyLabel.text! as NSString
        let matchRange = longString.range(of: "EULA".toLocalize())
        let matchRange1 = longString.range(of: "Privacy_Policy".toLocalize())
        let matchRange2 = longString.range(of: "Restore".toLocalize())
        if self.checkIndex(index: charIndex, inRange: matchRange)  {
            DispatchQueue.main.async {
                self.openEULA()
            }

        }
        else if self.checkIndex(index: charIndex, inRange: matchRange1)  {
            DispatchQueue.main.async {
                self.openPrivacyPage()
            }

        }
        else if self.checkIndex(index: charIndex, inRange: matchRange2)  {
            DispatchQueue.main.async {
                self.openRestore()
            }
        }
        return true
    }
    
    func label(_ label: TapLabel!, didMove touch: UITouch!, onCharacterAt charIndex: CFIndex) -> Bool {
        return true
    }
    
    func label(_ label: TapLabel!, didBegin touch: UITouch!, onCharacterAt charIndex: CFIndex) -> Bool {
        return true
    }
    
    func checkIndex(index:CFIndex, inRange range:NSRange) -> Bool {
        return index > range.location && index < (range.location+range.length)
    }
}
extension SubscriptionViewController {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            if purchase.productId == PLANS.WEEKLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.WEEKLY.rawValue)" {
                UserClass.setWeeklySubscription(true)
            }
            else if purchase.productId == PLANS.WEEKLY_3DAYS_TRIAL.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.WEEKLY_3DAYS_TRIAL.rawValue)" {
                UserClass.setWeekly3DaysSubscription(true)
            }
            else if purchase.productId == PLANS.MONTHLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.MONTHLY.rawValue)" {
                UserClass.setMonthlySubscription(true)
            }
            else if purchase.productId == PLANS.YEARLY.rawValue || purchase.productId == "\(Constants.BundleId).\(PLANS.YEARLY.rawValue)" {
                UserClass.setYearlySubscription(true)
            }
            self.purchaseSuccess()
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }
}
class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func networkOperationStarted() {
        
        #if os(iOS)
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
        #endif
    }
    
    class func networkOperationFinished() {
        #if os(iOS)
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        #endif
    }
}
