//
//  HypeTableViewCell.swift
//  TESwift
//
//  Created by Apple on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class HypeTableViewCell: UITableViewCell {

    @IBOutlet  var hypeBgImg: UIImageView!
    @IBOutlet  var hypeBorderImg: UIImageView!
    @IBOutlet  var hypNameLbl: UILabel!
    @IBOutlet  var gameLbl: UILabel!
    @IBOutlet  var locationLbl: UILabel!
    @IBOutlet  var dateLbl: UILabel!
    @IBOutlet var progressBar: UIActivityIndicatorView!
    
    var colorString:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
