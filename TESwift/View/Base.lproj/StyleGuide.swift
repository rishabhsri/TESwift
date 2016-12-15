//
//  StyleGuide.swift
//  TESwift
//
//  Created by V Group Inc. on 12/14/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import Foundation

func placeHolderFontColor() -> UIColor {
    var color = UIColor(red: CGFloat(160 / 255.0), green: CGFloat(160 / 255.0), blue: CGFloat(160 / 255.0), alpha: CGFloat(0.5))
    return color
}

func labelBlueColor() -> UIColor {
    var color = UIColor(red: CGFloat(124 / 255.0), green: CGFloat(198 / 255.0), blue: CGFloat(228 / 255.0), alpha: CGFloat(1))
    return color
}

func fontFutaraRegular(withFontSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: "Futura-Boo", size: fontSize)!
}

func fontFutaraBold(withFontSize fontsize: CGFloat) -> UIFont {
    return UIFont(name: "Futura-Bold", size: fontsize)!
}
