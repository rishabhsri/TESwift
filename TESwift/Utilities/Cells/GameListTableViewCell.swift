//
//  GameListTableViewCell.swift
//  TESwift
//
//  Created by Apple on 28/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class GameListTableViewCell: UITableViewCell {

    @IBOutlet weak var gameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
