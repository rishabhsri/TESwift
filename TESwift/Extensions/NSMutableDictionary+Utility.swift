//
//  NSMutableDictionary+Utility.swift
//  TESwift
//
//  Created by Apple on 30/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

extension NSMutableDictionary
{
    
    func setCustomObject(object:Any?,key:String)
    {
        if object == nil
        {
            return
        }
        if object is String
        {
            if let str:String = object as? String
            {
                if str.isEmpty
                {
                    return
                }else
                {
                    self.setValue(object, forKey: key)
                }
            }
        }else if object is Bool
        {
            if let value:Bool = object as? Bool
            {
                self.setValue(NSNumber.init(value: value), forKey: key)
            }
        }else if object is NSString
        {
            if let str:String = object as? String
            {
                if str.isEmpty
                {
                    return
                }else
                {
                    self.setValue(object, forKey: key)
                }
            }
        }
    }
}
