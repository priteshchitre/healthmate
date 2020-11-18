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
