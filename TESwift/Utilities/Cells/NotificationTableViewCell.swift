//
//  NotificationTableViewCell.swift
//  TESwift
//
//  Created by Apple on 15/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var notificationTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (IS_IPHONE) {
            self.notificationTextView.font = StyleGuide.fontFutaraRegular(withFontSize: 16)
        }
        else{
            self.notificationTextView.font = StyleGuide.fontFutaraRegular(withFontSize: 21)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
