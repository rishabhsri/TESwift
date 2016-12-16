//
//  LeftMenuViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController {
    
    // Outlets for UI elements
    @IBOutlet weak var backGround_BG: UIImageView!
    
    @IBOutlet weak var userProImage: UIImageView!
    
    @IBOutlet weak var displayNameLbl: UILabel!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpData(userInfo: commonSetting.userLoginInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpData(userInfo: NSDictionary) -> Void {
        
        self.displayNameLbl.text = userInfo.value(forKey: "name") as? String
        self.userNameLbl.text = String(format: "@%@", (userInfo.value(forKey: "username") as? String)!)
        
        let imageKey = commonSetting.imageKeyProfile
        
        if !commonSetting.isEmptySting(imageKey!)
        {
            //On Success Call
            let success:downloadImageSuccess = {image,imageKey in
                // Success call implementation
                
                self.userProImage.setRoundedImage(image: image, borderWidth: 0, imageWidth: self.userProImage.frame.size.width)
                
                self.backGround_BG.image = image
                
                self.setBlurImage(imageView: self.backGround_BG)
                
            }
            
            //On Falure Call
            let falure:downloadImageFailed = {error,responseMessage in
                
                // Falure call implementation
                
            }
            
            ServiceCall.sharedInstance.downloadImage(imageKey: imageKey!, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func tournamentAction(_ sender: AnyObject) {
    }
    
    @IBAction func seasonAction(_ sender: AnyObject) {
    }
    
    @IBAction func eventAction(_ sender: AnyObject) {
    }
    
    @IBAction func myTeamAction(_ sender: AnyObject) {
    }
    
    @IBAction func followingAction(_ sender: AnyObject) {
    }
    
    @IBAction func settingAction(_ sender: AnyObject) {
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        _ =  self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func syncToSerAction(_ sender: AnyObject) {
    }
}
