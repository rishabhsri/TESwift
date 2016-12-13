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
}
