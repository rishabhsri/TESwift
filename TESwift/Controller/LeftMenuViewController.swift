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
    @IBOutlet weak var tournamentYPos: NSLayoutConstraint!
    @IBOutlet var yPositions: [NSLayoutConstraint]!
    
    public var currentNavVC:UINavigationController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.userProImage.setRoundedImage(image: UIImage(named:"UserDefaultImage")!, borderWidth: 0, imageWidth: self.userProImage.frame.size.width)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setUpData()
        
        self.updateConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateConstraints() {
        
        var verticalSpacing:CGFloat = 15
        if DeviceType.IS_IPHONE_5
        {
            verticalSpacing = 10
            self.tournamentYPos.constant = 15
        }else if DeviceType.IS_IPHONE_6
        {
            self.tournamentYPos.constant = 25
            verticalSpacing = 20
        }else if (DeviceType.IS_IPHONE_6P || IS_IPAD)
        {
            self.tournamentYPos.constant = 35
            verticalSpacing = 30
        }
        
        for constraint:NSLayoutConstraint in yPositions {
            constraint.constant = verticalSpacing
        }
        self.view.setNeedsLayout()
    }
    
    func setCurrentNavigationController(navVC:UINavigationController)
    {
        self.currentNavVC = navVC
    }
    
    func setUpData() -> Void
    {
        let predicate = NSPredicate(format: "username == %@", (commonSetting.userDetail?.userName)!)
        commonSetting.myProfile = TEMyProfile.fetchMyProfileDetail(context: self.manageObjectContext(), predicate: predicate)
        
        self.displayNameLbl.text = commonSetting.myProfile?.name?.uppercased()
        
        self.userNameLbl.text = commonSetting.myProfile?.username
        
        if let imagekey:String = commonSetting.myProfile?.imageKey
        {
            if !(commonSetting.isEmptyStingOrWithBlankSpace(imagekey))
            {
                //On Success Call
                let success:downloadImageSuccess = {image,imageKey in
                    // Success call implementation
                    
                    self.userProImage.setRoundedImage(image: image, borderWidth: 0, imageWidth: self.userProImage.frame.size.width)
                    
                    self.backGround_BG.image = image
                    
                    self.setBlurImage(imageView: self.backGround_BG,imageKey:imageKey.appending("_leftMenu"))
                }
                
                //On Falure Call
                let falure:downloadImageFailed = {error,responseMessage in
                    // Falure call implementation
                }
                
                ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func tournamentAction(_ sender: AnyObject)
    {
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let tournamentListVC:TournamentListViewController = storyBoard.instantiateViewController(withIdentifier: "TournamentListViewControllerID") as! TournamentListViewController
        self.setFrontVC(frontVC: tournamentListVC)
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC:SettingViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController
        self.setFrontVC(frontVC: settingVC)
        
    }
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        _ =  self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func syncToSerAction(_ sender: AnyObject)
    {
    }
    @IBAction func profileAction(_ sender: Any)
    {
        if currentNavVC?.childViewControllers.first is MyDashBoardViewController
        {
            appDelegate.menuController?.revealToggle(self)
        }else
        {
            let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
            let dashBoardVC:MyDashBoardViewController = storyBoard.instantiateViewController(withIdentifier: "MyDashBoardViewControllerID") as! MyDashBoardViewController
            self.setFrontVC(frontVC: dashBoardVC)
        }
    }
    
    func setFrontVC(frontVC:UIViewController) {
        currentNavVC = UINavigationController.init(rootViewController: frontVC)
        currentNavVC?.navigationBar.isHidden = true
        appDelegate.menuController?.setFront(currentNavVC, animated: true)
        appDelegate.menuController?.revealToggle(self)
    }
}
