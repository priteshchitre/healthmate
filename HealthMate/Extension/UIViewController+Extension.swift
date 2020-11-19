//
//  UIViewController+Extension.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    func setNavigationTitle(navigationItem : UINavigationItem, title : String) {
        
        navigationItem.titleView = UIView()
        
        var labelFrame : CGRect!
        labelFrame = CGRect(x: 0, y: 0, width: (self.navigationItem.titleView?.frame.size.width)!, height: 44)

        let label1 : UILabel = UILabel(frame: labelFrame)
        label1.text = title
        label1.font = UIFont.customFont(name: Font.RobotoBold, size: 25)
        label1.textAlignment = .center
        label1.textColor = UIColor.black
        label1.tag = 10001
        label1.minimumScaleFactor = 0.5
        self.navigationItem.titleView = label1
    }
    
    func setBackBarButton(_ isHidden : Bool = false) {
        
        let backButton : UIButton = UIButton()
        backButton.setImage(UIImage(named: "Status-Bar-back Arrow-2"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onBackButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.imageWith(color: UIColor.black, for: UIControl.State.normal)
        backButton.isHidden = isHidden
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    func setGrayBackBarButton() {
        
        let backButton : UIButton = UIButton()
        backButton.setImage(UIImage(named: "Status-Bar-back Arrow-2"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onBackButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.imageWith(color: Color.appOrange, for: UIControl.State.normal)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    func setMenuBarButton(_ isHidden : Bool = false) {
        
        let backButton : UIButton = UIButton()
        backButton.setImage(UIImage(named: "menu"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onMenuButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.imageWith(color: UIColor.black, for: UIControl.State.normal)
        backButton.isHidden = isHidden
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func onMenuButtonTapped() {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func setCancelBarButton() {
        
        let backButton : UIButton = UIButton()
        backButton.setTitle("Cancel".toLocalize(), for: UIControl.State.normal)
        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.titleLabel?.textAlignment = .right
        backButton.sizeToFit()
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onCancelButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    
    
    @objc func onBackButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onCancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIButton {
    func imageWith(color:UIColor, for: UIControl.State) {
        if let imageForState = self.image(for: state) {
            self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            let colorizedImage = imageForState.image(withTintColor: color)
            self.setImage(colorizedImage, for: state)
        }
    }
}
extension UIImage {
    public func image(withTintColor color: UIColor) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
extension UIImageView {
    
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
}
extension CALayer {
    
    func addCustomShadow() {
        
//        self.masksToBounds = false
//        self.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
//        self.shadowOpacity = 0.4
//        self.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.shadowRadius = 2
        self.cornerRadius = 8
        self.borderWidth = 0.25
        self.borderColor = UIColor.white.cgColor
        self.shadowOpacity = 0.5
        self.shadowRadius = 6.0
        self.shadowOffset = CGSize.zero // Use any CGSize
        self.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
    }
}
public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
