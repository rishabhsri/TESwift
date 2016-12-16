//
//  String+Utilities.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

extension String {
    
    func convertToDictionary(text: String) -> NSDictionary {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    
   public static func dateStringFromString(sourceString:String,format:String) -> String {
        
        var convertedDateString:String = ""
        var dateFormatterList = [String]()
        dateFormatterList.append("yyyy-MM-dd'T'HH:mm:ss'Z'")
        dateFormatterList.append("yyyy-MM-dd'T'HH:mm:ssZ")
        
        dateFormatterList.append("yyyy-MM-dd'T'HH:mm:ss")
        dateFormatterList.append("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        dateFormatterList.append("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        dateFormatterList.append("yyyy-MM-dd HH:mm:ss")
        dateFormatterList.append("MM/dd/yyyy HH:mm:ss")
        dateFormatterList.append("MM/dd/yyyy'T'HH:mm:ss.SSS'Z'")
        dateFormatterList.append("MM/dd/yyyy'T'HH:mm:ss.SSSZ")
        dateFormatterList.append("MM/dd/yyyy'T'HH:mm:ss.SSS")
        dateFormatterList.append("MM/dd/yyyy'T'HH:mm:ssZ")
        dateFormatterList.append("MMMM, yyyy")
        dateFormatterList.append("d'th' MMM")
        dateFormatterList.append("yyyy")
        dateFormatterList.append("MMMM yyyy")
        dateFormatterList.append("dd MMMM yyyy")
        dateFormatterList.append("d'th' MMM yyyy")
        dateFormatterList.append("d'st' MMMM")
        dateFormatterList.append("d'nd' MMM yyyy")
        dateFormatterList.append("d'rd' MMM yyyy")
        dateFormatterList.append("d'st' MMM yyyy")
        dateFormatterList.append("d'th' MMMM yyyy")
        dateFormatterList.append("d'rd' MMMM yyyy")
        dateFormatterList.append("d'nd' MMMM yyyy")
        dateFormatterList.append("d'st' MMMM yyyy")
        dateFormatterList.append("MM-dd-yyyy")
        dateFormatterList.append("MM/dd/yyyy")
        dateFormatterList.append("MMddyyyy")
        dateFormatterList.append("yyyy/MM/dd")
        dateFormatterList.append("d'rd' MMMM")
        dateFormatterList.append("d'nd' MMMM")
        dateFormatterList.append("d'th' MMMM")
        dateFormatterList.append("d'st' MMM")
        dateFormatterList.append("d'nd' MMM")
        dateFormatterList.append("d'rd' MMM")
        dateFormatterList.append("yyyy-MM-dd")
        dateFormatterList.append("dd/MM/yyyy")
        dateFormatterList.append("yyyyMMdd")
        dateFormatterList.append("dd-MM-yyyy")
        dateFormatterList.append("yyyy:MM:dd HH:mm:ss")
        dateFormatterList.append("MM/dd/yyyy'T'HH:mm:ss")
        
        
        if !commonSetting.isEmptySting(sourceString) {
            let dateFormatter:DateFormatter = DateFormatter()
            
            for dateFormatterString:String in dateFormatterList  {
                dateFormatter.dateFormat = dateFormatterString
                dateFormatter.timeZone = NSTimeZone(name:"GMT") as TimeZone!
                if let originalDate:Date = dateFormatter.date(from: sourceString)
                {
                    dateFormatter.timeZone = NSTimeZone.system
                    dateFormatter.dateFormat = format
                    convertedDateString = dateFormatter.string(from: originalDate)
                    break
                }
            }
        }
        return convertedDateString
    }
    
}
