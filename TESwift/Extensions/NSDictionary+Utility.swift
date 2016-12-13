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
    
}

