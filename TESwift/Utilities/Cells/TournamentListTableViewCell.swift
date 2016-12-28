//
//  TournamentListTableViewCell.swift
//  TESwift
//
//  Created by Apple on 23/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class TournamentListTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var borderImage: UIImageView!
    @IBOutlet weak var tournmentName: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
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
