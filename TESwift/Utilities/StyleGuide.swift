//
//  StyleGuide.swift
//  TESwift
//
//  Created by V Group Inc. on 12/14/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation

public class StyleGuide
{
    public static func placeHolderFontColor() -> UIColor {
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(255.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(0.25))
        return color
    }
    
    public static func labelBlueColor() -> UIColor {
        let color = UIColor(red: CGFloat(124 / 255.0), green: CGFloat(198 / 255.0), blue: CGFloat(228 / 255.0), alpha: CGFloat(1))
        return color
    }
    
    public static func fontFutaraRegular(withFontSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Futura-Boo", size: fontSize)!
    }
    
    public static func fontFutaraBold(withFontSize fontsize: CGFloat) -> UIFont {
        return UIFont(name: "Futura-Bold", size: fontsize)!
    }
    
    public static func tableViewRightView() -> UIColor
    {
        if IS_IPAD {
            return UIColor.clear
        }
        else
        {
        return UIColor.init(colorLiteralRed: 47.0/255.0, green: 88.0/255.0, blue: 105.0/255.0, alpha: 1)
        }
    }
    
    public static func highlightedSearchedText(name:String, searchedText:String) -> NSMutableAttributedString
    {
        if name.isEmpty {
            return NSMutableAttributedString()
        }
        
        let attributesForHeaderString:[String : Any] = [NSForegroundColorAttributeName : UIColor.lightGray]
        let attributedStringMessage = NSMutableAttributedString(string: name, attributes: attributesForHeaderString)
        let range = (name.uppercased() as NSString).range(of:searchedText.uppercased())
        attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: range)
        return attributedStringMessage
    }
}
