//
//  SearchTableViewCell.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 23/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font = StyleGuide.fontFutaraRegular(withFontSize: IS_IPHONE ? 15 : 17)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
