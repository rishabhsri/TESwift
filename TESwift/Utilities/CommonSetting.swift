//
//  CommonSetting.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class CommonSetting: NSObject {
    
    var userLoginInfo:NSDictionary = NSDictionary()
    var imageKeyProfile:String?
    var isInternetAvailable:Bool = false
    var listViewColors:[String] = [String]()
    
    //Methods
    class var sharedInstance: CommonSetting {
        struct Singleton {
            static let instance = CommonSetting()
        }
        return Singleton.instance
    }
    override init() {
        self.listViewColors = ["#2F363C","#50373B","#5E4D3B","#313B33","#4E504B","#314F5B","#4C555C","#385253","#4E4946","#1D4657","#5D6C73","#A28F6E"]
    }
    
    func validatePassword(password:String) -> Bool {
        return true
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", kPasswordRegex)
        
        if predicate.evaluate(with: predicate) {
            return true
        }else
        {
            return false
        }
    }
    
    func validateNumber(_ number: String) -> Bool {
        let usernameRegEx = "^[0-9]+$"
        let usernameValidator = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return usernameValidator.evaluate(with: number)
    }

    func validateEmailID(emailID:String) -> Bool {
        
        let emailString = emailID.replacingOccurrences(of: " ", with: "")
        if emailString.characters.count == emailID.characters.count {
            let filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", filterString)
            return predicate.evaluate(with: emailID)
        }else
        {
            return false
        }
    }
    
    func isEmptyStingOrWithBlankSpace(_ text: String) -> Bool {
        
        if text.isEmpty{
            return true
        }
        if (text.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines) != nil) {
            return true
        }
        return false
    }
    
    func isEmptySting(_ text: String) -> Bool {
        
        if text.isEmpty{
            return true
        }
        return false
    }
    
    func animateProfileImage(imageView:UIImageView) {
        
        let estimateCorner:CGFloat = imageView.bounds.size.width / 2
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear) //[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = imageView.layer.cornerRadius
        animation.toValue = estimateCorner
        animation.duration = 0.25;
        imageView.layer.cornerRadius = estimateCorner
        imageView.layer.add(animation, forKey: "cornerRadius")
    }
}
