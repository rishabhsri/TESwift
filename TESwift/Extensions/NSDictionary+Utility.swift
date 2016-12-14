//
//  NSDictionary+Utility.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 13/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

extension NSDictionary {
    
    func stringValueForKey(key:String) -> String {
        
        var strValue:String = ""
        
        if let value:String = self.value(forKey: key) as? String
        {
            strValue = value
            
        }else if let value:NSNumber = self.value(forKey: key) as? NSNumber
        {
            strValue = String.init(format: "%@", value)
            
        }
        
        return strValue
    }
    
    func intValueForKey(key:String) -> Int {
        
        var intValue:Int = 0
        
        if let value:Int = self.value(forKey: key) as? Int
        {
            intValue = value
            
        }else if let value:NSNumber = self.value(forKey: key) as? NSNumber
        {
            intValue = Int(value)
            
        }
        return intValue
    }
    
    func boolValueForKey(key:String) -> Bool {
        
        var boolValue:Bool = false
        
        if let value:Bool = self.value(forKey: key) as? Bool
        {
            boolValue = value
            
        }else if let value:NSNumber = self.value(forKey: key) as? NSNumber
        {
            boolValue = Bool(value)
            
        }
        return boolValue
    }

    
}

