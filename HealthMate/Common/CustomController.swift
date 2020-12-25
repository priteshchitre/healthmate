//
//  CustomController.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit

class RoundButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = UIFont.customFont(name: Font.RobotoBold, size: 18)
        self.layer.cornerRadius = 8
        self.backgroundColor = Color.roundButtonColor
        self.setTitleColor(Color.roundButtonTextColor, for: UIControl.State.normal)
    }
}
class SquareTextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layoutIfNeeded()
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.font = UIFont.customFont(name: Font.RobotoRegular, size: 16)
        self.clearButtonMode = .whileEditing
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            
//            self.addBottomBorderWithColor(color: UIColor(red: 49, green: 51, blue: 51), width: 2)
//            self.modifyClearButton(with: UIColor(red: 49, green: 51, blue: 51))
        }
        
    }
}
class CustomTextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layoutIfNeeded()
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.font = UIFont.customFont(name: Font.RobotoRegular, size: 16)
        self.clearButtonMode = .whileEditing
    }
}
class BoxTextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layoutIfNeeded()
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.white

        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.font = UIFont.customFont(name: Font.RobotoRegular, size: 16)
        self.clearButtonMode = .whileEditing
    }
}
class DropDownTextField : UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor

        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.font = UIFont.customFont(name: Font.RobotoRegular, size: 16)
        
        self.rightViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageView.image = UIImage(named: "Arrow_down")
        rightView.addSubview(imageView)
        
        let button = UIButton(frame: rightView.frame)
        button.addTarget(self, action: #selector(self.onRightButtonTapped), for: UIControl.Event.touchUpInside)
        
        rightView.tag = 999
        rightView.addSubview(button)
        
        self.rightView = rightView
    }
    
    @objc func onRightButtonTapped() {
        self.becomeFirstResponder()
    }
}
class CircularProgressView: UIView {
    
    var progressLyr = CAShapeLayer()
    var trackLyr = CAShapeLayer()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }
    var progressClr = UIColor.white {
        didSet {
            progressLyr.strokeColor = progressClr.cgColor
        }
    }
    var trackClr = UIColor.white {
        didSet {
            trackLyr.strokeColor = trackClr.cgColor
        }
    }
    func makeCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        trackLyr.path = circlePath.cgPath
        trackLyr.fillColor = UIColor.clear.cgColor
        trackLyr.strokeColor = trackClr.cgColor
        trackLyr.lineWidth = 20.0
        //        trackLyr.strokeEnd = 1.0
        layer.addSublayer(trackLyr)
        progressLyr.path = circlePath.cgPath
        progressLyr.fillColor = UIColor.clear.cgColor
        progressLyr.strokeColor = progressClr.cgColor
        progressLyr.lineWidth = 20.0
        progressLyr.strokeEnd = 0.0
        progressLyr.strokeStart = 0
        progressLyr.strokeEnd = 0.22
        layer.addSublayer(progressLyr)
    }
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLyr.strokeEnd = CGFloat(value)
        progressLyr.add(animation, forKey: "animateprogress")
    }
}
extension UITextField {
    @objc func modifyClearButton(with imageColor : UIColor) {
        
        let image = UIImage(named: "Clear")?.image(withTintColor: imageColor)
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing
    }
    
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
//        if delegate?.textFieldShouldClear?(self) == true {
//            self.text = ""
//            sendActions(for: .editingChanged)
//        }
    }
}
