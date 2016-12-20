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
        let color = UIColor(red: CGFloat(160 / 255.0), green: CGFloat(160 / 255.0), blue: CGFloat(160 / 255.0), alpha: CGFloat(0.5))
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
}
