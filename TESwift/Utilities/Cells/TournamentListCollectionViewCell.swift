//
//  TournamentListCollectionViewCell.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 23/01/17.
//  Copyright © 2017 V group Inc. All rights reserved.
//

import UIKit

class TournamentListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var borderImage: UIImageView!
    
    @IBOutlet weak var tournamentName: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    var colorString:String?
    
   
      
}
