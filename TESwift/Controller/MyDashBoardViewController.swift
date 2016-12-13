//
//  MyDashBoardViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class MyDashBoardViewController: BaseViewController {
    
    
    //TopView outlets
    @IBOutlet weak var topViewBGImg: UIImageView!
    @IBOutlet weak var userProImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    
    //Bottomview outlets
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var hypBtn: UIButton!
    @IBOutlet weak var tournamentsBtn: UIButton!
    @IBOutlet weak var tableViewbtn: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    //autolayout constants                              // Actual values
    @IBOutlet weak var menuBtnTop: NSLayoutConstraint!  // 30
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!// 40
    @IBOutlet weak var usernameTop: NSLayoutConstraint!// 21
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!//317
    
    //Arrays for Hype, tournaments and notifications
    var hypetoShowArray:NSArray = NSArray()
    var tournamentsToShowArray:NSArray = NSArray()
    var notificationToShowArray:NSArray = NSArray()
    
    
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMenu()
        
        self.setupData()
        
        self.setUpStyleGuide()
        
        self.getUserProfileData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utilities
    
    func setUpStyleGuide() -> Void {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
    }
    
    func setupData() -> Void {
        self.userNameLbl.text = self.userDataDict.value(forKey: "name") as! String?;
        self.emaillbl.text = self.userDataDict.value(forKey: "email") as! String?;
        
    }
    
    func setupMenu() -> Void {
        if  revealViewController() != nil {
            menuButton.target(forAction: #selector(SWRevealViewController.revealToggle(_:)), withSender: AnyObject.self)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    func getUserProfileData() -> Void {
        
        //On success
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            
            if responseType == RequestedUrlType.GetUserProfileData {
                self.configureHypeArray(userData: responseDict)
                self.configureTournamentArray(userData: responseDict)
            }
            else if responseType == RequestedUrlType.GetAllNotification
            {
                self.configureNotificationArray(userData: responseDict)
            }
            
        }
        let failure: falureHandler = {error, responseString, responseType in
        
        print(responseString)
        }
        
        let userInfo:NSMutableDictionary = NSMutableDictionary()
        userInfo.setValue("", forKey: "Nothing")
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetUserProfileData, method: "GET", successCall: success, falureCall: failure)
        
        // Service call for notifications
        ServiceCall.sharedInstance.sendRequest(parameters: userInfo, urlType: RequestedUrlType.GetAllNotification, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func configureHypeArray(userData: NSDictionary) -> Void {
        
       self.hypetoShowArray = userData.object(forKey: "hypes") as! NSArray
    }
    
    func configureTournamentArray(userData: NSDictionary) -> Void {
        
        self.tournamentsToShowArray = userData.object(forKey: "upcoming") as! NSArray
    }
    
    func configureNotificationArray(userData: NSDictionary) -> Void {
        
  //      self.notificationToShowArray = userData.object(forKey: "upcoming") as! NSArray
    }


    
    // MARK: - IBOutlet Actions
    @IBAction func notificationAction(_ sender: AnyObject) {
        
        self.notificationBtn.alpha = 1.0
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 0.25
    }
    
    @IBAction func tournamentAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 1.0
    }
    
    @IBAction func hypeAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
    }
    
    
    
}
