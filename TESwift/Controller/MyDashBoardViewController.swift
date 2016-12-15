//
//  MyDashBoardViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class MyDashBoardViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    //TopView outlets
    @IBOutlet weak var topViewBGImg: UIImageView!
    @IBOutlet weak var userProImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    
    //Bottomview outlets
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var hypBtn: UIButton!
    @IBOutlet weak var tournamentsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    //autolayout constants                              // Actual values
    @IBOutlet weak var menuBtnTop: NSLayoutConstraint!  // 30
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!// 140
    @IBOutlet weak var usernameTop: NSLayoutConstraint!// 21
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!//317
    @IBOutlet weak var profileImageTop: NSLayoutConstraint!//40
    @IBOutlet weak var emailTop: NSLayoutConstraint!// 5
    
    //Local Variables
    var isSwipedUp = false
    var currentButtonIndex:NSInteger = 0
    
    //Arrays for Hype, tournaments and notifications
    var hypetoShowArray:NSArray = NSArray()
    var tournamentsToShowArray:NSArray = NSArray()
    var notificationToShowArray:NSArray = NSArray()
    var userProfileInfo:NSMutableDictionary = NSMutableDictionary()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(hypeTableViewCell.self, forCellReuseIdentifier:"Cell")
        
        self.setUpStyleGuide()
        
        self.setupMenu()
        
        self.setupData()
        
        self.saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
        
        
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
        currentButtonIndex = 1
    }
    
    func setupData() -> Void {
        
        self.addSwipeGesture()
        
        self.setProfileData(userInfo: commonSetting.userLoginInfo)
        
        self.getUserProfileData()
        
    }
    
    func saveUserDetails(loginInfo: NSDictionary) -> Void {
        
        //        let userInfo:NSMutableDictionary = NSMutableDictionary()
        //
        //        userInfo.setValue(loginInfo.value(forKey: "name"), forKey: "name")
        //        userInfo.setValue(loginInfo.value(forKey: "email"), forKey: "email")
        //        userInfo.setValue(loginInfo.value(forKey: "userID"), forKey: "userID")
        //        userInfo.setValue(loginInfo.value(forKey: "username"), forKey: "username")
        //        userInfo.setValue(loginInfo.value(forKey: "userSubscription") as! Bool, forKey: "userSubscription")
        //
        //        _ = UserDetails.insertUserDetails(info:userInfo, context:self.manageObjectContext())
        //        UserDetails.save(self.manageObjectContext())
        //
        //        let predi = NSPredicate(format: "age = %d", 33)
        //        let user = UserDetails.fetchUserDetailsFor(context: self.manageObjectContext(), predicate: predi)
        //        print(user)
    }
    
    func setProfileData(userInfo:NSDictionary) {
        
        self.userNameLbl.text = userInfo.stringValueForKey(key: "name").uppercased()
        self.emaillbl.text = userInfo.stringValueForKey(key: "email")
        let imagekey:String = userInfo.stringValueForKey(key: "imageKey")
        
        if !commonSetting.isEmptySting(imagekey)
        {
            // For storing temporary imageKey for using in MenuViewController
            
            commonSetting.imageKeyProfile = imagekey
            //On Success Call
            let success:downloadImageSuccess = {image,imageKey in
                // Success call implementation
                
                self.userProImage.setRoundedImage(image: image, borderWidth: ProfileImageBorder, imageWidth: self.profileImageWidth.constant)
                self.topViewBGImg.image = image
                
                self.setBlurImage(imageView: self.topViewBGImg)
                
            }
            
            //On Falure Call
            let falure:downloadImageFailed = {error,responseMessage in
                
                // Falure call implementation
                
            }
            
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: success, falureCall: falure)
        }
    }
    
    
    func setupMenu() -> Void {
        if  revealViewController() != nil {
            menuButton.addTarget(revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    
    func getUserProfileData(){
        
        //On success
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            
            if responseType == RequestedUrlType.GetUserProfileData {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "hypes") as? NSArray
                {
                    self.hypetoShowArray = array
                }
                //initialize tournament list
                if let array:NSArray =  responseDict.object(forKey: "upcoming") as? NSArray
                {
                    self.tournamentsToShowArray = array
                }
                
                //Parse User Data
                self.parseUserInfo(userInfo: responseDict.object(forKey: "person") as! NSDictionary)
                
            }else if responseType == RequestedUrlType.GetAllNotification
            {
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    self.notificationToShowArray = array
                }
            }
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetUserProfileData, method: "GET", successCall: success, falureCall: failure)
        
        // Service call for notifications
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetAllNotification, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func parseUserInfo(userInfo:NSDictionary) {
        
        self.userProfileInfo.setDictionary(userInfo as! [AnyHashable : Any])
        self.userProfileInfo.addEntries(from: commonSetting.userLoginInfo as! [AnyHashable : Any])
        self.setProfileData(userInfo: self.userProfileInfo)
        self.tableView.reloadData()
        
    }
    
    //MARK:- SwipeGesture methods
    
    func addSwipeGesture(){
        
        let swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MyDashBoardViewController.swipeUpHandler(sender:)))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.up
        
        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MyDashBoardViewController.swipeDownHandler(sender:)))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
        
        self.topViewBGImg.addGestureRecognizer(swipeUpGesture)
        self.topViewBGImg.addGestureRecognizer(swipeDownGesture)
    }
    
    func swipeUpHandler(sender:UISwipeGestureRecognizer){
        
        if self.isSwipedUp {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.profileImageWidth.constant = 70
            self.headerViewHeight.constant = 182
            self.profileImageTop.constant = 15
            self.menuBtnTop.constant = 15
            self.usernameTop.constant = 4
            self.emailTop.constant = 2
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            }, completion: {(isCompleted) -> Void in
                self.isSwipedUp = true
        })
        
        commonSetting.animateProfileImage(imageView: self.userProImage)
        
    }
    func swipeDownHandler(sender:UISwipeGestureRecognizer){
        
        if !self.isSwipedUp {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.profileImageWidth.constant = 140
            self.headerViewHeight.constant = 317
            self.profileImageTop.constant = 40
            self.menuBtnTop.constant = 30
            self.usernameTop.constant = 21
            self.emailTop.constant = 5
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            }, completion: {(isCompleted) -> Void in
                self.isSwipedUp = false
        })
        
        commonSetting.animateProfileImage(imageView: self.userProImage)
    }
    
    // MARK: - IBOutlet Actions
    @IBAction func notificationAction(_ sender: AnyObject) {
        
        self.notificationBtn.alpha = 1.0
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 0
        
    }
    
    @IBAction func tournamentAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 1.0
        currentButtonIndex = 2
        self.tableView.reloadData()
    }
    
    @IBAction func hypeAction(_ sender: AnyObject) {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 1
        self.tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentButtonIndex == 0 {
            return 2
        }else if currentButtonIndex == 1
        {
            return hypetoShowArray.count
        }else
        {
            return tournamentsToShowArray.count
        }
    }
   
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        let cell:UITableViewCell
        if currentButtonIndex == 0 {
            cell = self.configureHypeCell(tableView: tableView, indexPath: indexPath)
        }else if currentButtonIndex == 1
        {
            cell = self.configureHypeCell(tableView: tableView, indexPath: indexPath)
            
        }else
        {
            cell = self.configureTournamentCell(tableView: tableView, indexPath: indexPath)
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func  configureHypeCell(tableView:UITableView, indexPath:IndexPath) -> hypeTableViewCell {
        
        let cell:hypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hypeTableViewCell", for: indexPath) as! hypeTableViewCell
        
        let hypeInfo:NSDictionary = self.parseResponse(responseObject: hypetoShowArray.object(at: indexPath.row))
        cell.hypeBorderImg.image = UIImage(named: "HypeImageBorder")
        cell.hypNameLbl.text = hypeInfo.stringValueForKey(key: "name")
        cell.gameLbl.text = hypeInfo.stringValueForKey(key: "game")
        cell.locationLbl.text = hypeInfo.stringValueForKey(key: "venue")
        cell.dateLbl.text = hypeInfo.stringValueForKey(key: "startDate")
        
        return cell
    }
    
    func  configureTournamentCell(tableView:UITableView, indexPath:IndexPath) -> hypeTableViewCell {
        
        let cell:hypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hypeTableViewCell", for: indexPath) as! hypeTableViewCell
        
        let hypeInfo:NSDictionary = self.parseResponse(responseObject: tournamentsToShowArray.object(at: indexPath.row))
       
        cell.hypeBorderImg.image = UIImage(named: "ImageBorder")
        cell.hypNameLbl.text = hypeInfo.stringValueForKey(key: "name")
        cell.gameLbl.text = hypeInfo.stringValueForKey(key: "game")
        cell.locationLbl.text = hypeInfo.stringValueForKey(key: "venue")
        cell.dateLbl.text = hypeInfo.stringValueForKey(key: "startDate")

        
        return cell
    }
}
