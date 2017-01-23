//
//  HypeCollectionViewCell.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 20/01/17.
//  Copyright © 2017 V group Inc. All rights reserved.
//

import UIKit

class HypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hypeBgImg: UIImageView!
    @IBOutlet weak var hypeBorderImg: UIImageView!
    @IBOutlet weak var hypeNameLbl: UILabel!
    
    @IBOutlet weak var gameLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    var colorString:String?
    
}
