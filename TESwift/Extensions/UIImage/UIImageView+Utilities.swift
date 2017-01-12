//
//  UIImageView+Utilities.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 13/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRoundedImage(image:UIImage,borderWidth:CGFloat,imageWidth:CGFloat) {
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = imageWidth/2;
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.init(red: 138, green: 138, blue: 138).cgColor
        self.layer.borderWidth = borderWidth;
        self.image = image;
    }
   
    
}

