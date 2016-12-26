//
//  MyDashBoardViewController.swift
//  TESwift
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class MyDashBoardViewController: UniversalSearchViewController{
    
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
 
    
    //autolayout constants                              // Actual values
    @IBOutlet weak var menuBtnTop: NSLayoutConstraint!  // 30
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!// 140
    @IBOutlet weak var usernameTop: NSLayoutConstraint!// 21
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!//317
    @IBOutlet weak var profileImageTop: NSLayoutConstraint!//40
    @IBOutlet weak var emailTop: NSLayoutConstraint!// 5
    @IBOutlet weak var searchBarTop: NSLayoutConstraint! // -44
    
    //Gestures
    
    var swipeUpGesture:UISwipeGestureRecognizer?
    var swipeDownGesture:UISwipeGestureRecognizer?
    
    //Local Variables
    var isSwipedUp = false
    var isResponseReceived = false
    var isTournamentLoadMore = false
    var isHypeLoadMore = false
    var isNotificationLoadMore = false
    var tournamentPageIndex:NSInteger = 0
    var hypePageIndex:NSInteger = 0
    var notificationPageIndex:NSInteger = 0
    var currentButtonIndex:NSInteger = 0
    
    //Arrays for Hype, tournaments and notifications
    var hypetoShowArray:NSMutableArray = NSMutableArray()
    var tournamentsToShowArray:NSMutableArray = NSMutableArray()
    var notificationToShowArray:NSMutableArray = NSMutableArray()
    var userProfileInfo:NSMutableDictionary = NSMutableDictionary()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpStyleGuide()
        
        self.setupData()
        
        self.saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
        self.getMyProfile()
        
        self.setupMenu()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utilities
    
    func setUpStyleGuide() -> Void {
        
        var fontSize:CGFloat = 17  //for iPad
        
        if IS_IPHONE {
            if DeviceType.IS_IPHONE_5 {
                fontSize = 12
            }else if DeviceType.IS_IPHONE_4_OR_LESS
            {
                fontSize = 10
            }else
            {
                fontSize = 15
            }
            self.notificationBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
            self.hypBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
            self.tournamentsBtn.titleLabel?.font = StyleGuide.fontFutaraBold(withFontSize: fontSize)
        }
    }
    
    func setupData() -> Void {
        
        self.configureSwipeGestures()
        
        self.resetLoadMore()
        
        self.setupTableView()
        
        self.setProfileData(userInfo: commonSetting.userLoginInfo)
        
        self.getUserProfileData()
        
        self.saveUserDetails(loginInfo: commonSetting.userLoginInfo)
        
    }
    
    func resetLoadMore() {
        self.isTournamentLoadMore = false
        self.isHypeLoadMore = false
        self.isNotificationLoadMore = false
        self.tournamentPageIndex = 0
        self.hypePageIndex = 0
        self.notificationPageIndex = 0
        self.currentButtonIndex = 0
    }
    
    func setupTableView() {
        self.notificationBtn.alpha = 0.25
        self.hypBtn.alpha = 1.0
        self.tournamentsBtn.alpha = 0.25
        self.currentButtonIndex = 1
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
    }
    
    func saveUserDetails(loginInfo: NSDictionary) -> Void {
        
        let userInfo:NSMutableDictionary = NSMutableDictionary()
        
        userInfo.setValue(loginInfo.stringValueForKey(key: "name"), forKey: "name")
        userInfo.setValue(loginInfo.stringValueForKey(key: "email"), forKey: "email")
        userInfo.setValue(loginInfo.stringValueForKey(key: "userID"), forKey: "userID")
        userInfo.setValue(loginInfo.stringValueForKey(key: "username"), forKey: "username")
        userInfo.setValue(loginInfo.intValueForKey(key: "userSubscription"), forKey: "userSubscription")
        
        _ = UserDetails.insertUserDetails(info:userInfo, context:self.manageObjectContext())
        UserDetails.save(self.manageObjectContext())
        
        let predi = NSPredicate(format: "userName == %@", loginInfo.stringValueForKey(key: "username"))
        let user = UserDetails.fetchUserDetailsFor(context: self.manageObjectContext(), predicate: predi)
        
        print(user.emailId!, user.name!, user.userName!, user.userId!, user.userSubscription)
    }
    
    func setProfileData(userInfo:NSDictionary) {
        
        self.userNameLbl.text = userInfo.stringValueForKey(key: "name").uppercased()
        self.emaillbl.text = userInfo.stringValueForKey(key: "email")
        let imagekey:String = userInfo.stringValueForKey(key: "imageKey")
        
        if !commonSetting.isEmptyStingOrWithBlankSpace(imagekey)
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
    
    
    
    
    func getMyProfile() {
        //On success
        
        let success: successHandler = {responseObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            TEMyProfile.deleteAllFormMyProfile(context:self.manageObjectContext())
            TEMyProfile.insertMyProfileDetail(myProfileInfo: responseDict, context: self.manageObjectContext())
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetMyProfile, method: "GET", successCall: success, falureCall: failure)
        
        
    }
    
    func getTournamentById(tournamentID:Int) -> Void {
        
        let tournamentDict:NSMutableDictionary = NSMutableDictionary()
        tournamentDict.setValue(tournamentID, forKey: "tournamentID")
        
        let success:successHandler = {responceObject, responseType in
            
            let responseDict = self.parseResponse(responseObject: responceObject as Any)
            print(responseDict)
            let tournamentList:TETournamentList = TETournamentList.insertTournamentDetails(info: responseDict, context: self.manageObjectContext(), isDummy: false, isUserHype: false)
            print(tournamentList.checkInTime!, tournamentList.completed)
        }
        
        let failure:falureHandler = {error, responseString, responseType in
            print(responseString)
            
        }
        
        ServiceCall.sharedInstance.sendRequest(parameters: tournamentDict, urlType: RequestedUrlType.GetTournamentById, method: "GET", successCall: success, falureCall: failure)
    }
    
    func parseUserInfo(userInfo:NSDictionary) {
        
        self.userProfileInfo.setDictionary(userInfo as! [AnyHashable : Any])
        self.userProfileInfo.addEntries(from: commonSetting.userLoginInfo as! [AnyHashable : Any])
        self.setProfileData(userInfo: self.userProfileInfo)
        
    }
    
    private func scrollViewWillEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    
    //MARK:- SwipeGesture methods
    
    func configureSwipeGestures()
    {
        
        self.swipeUpGesture = UISwipeGestureRecognizer()
        self.swipeUpGesture?.direction = UISwipeGestureRecognizerDirection.up
        
        self.swipeDownGesture = UISwipeGestureRecognizer()
        self.swipeDownGesture?.direction = UISwipeGestureRecognizerDirection.down
        
        self.addSwipeGestureOnDashboard()
    }
    
    func addSwipeGestureOnDashboard()
    {
        self.swipeUpGesture?.addTarget(self, action: #selector(MyDashBoardViewController.swipeUpHandler(sender:)))
        self.swipeDownGesture?.addTarget(self, action: #selector(MyDashBoardViewController.swipeDownHandler(sender:)))
        
        self.topViewBGImg.addGestureRecognizer(self.swipeUpGesture!)
        self.topViewBGImg.addGestureRecognizer(self.swipeDownGesture!)
    }
    
    func removeSwipeGestureFromDashBoard()
    {
        self.swipeUpGesture?.removeTarget(self, action: #selector(MyDashBoardViewController.swipeUpHandler(sender:)))
        self.swipeDownGesture?.removeTarget(self, action: #selector(MyDashBoardViewController.swipeDownHandler(sender:)))
        
        self.topViewBGImg.removeGestureRecognizer(self.swipeUpGesture!)
        self.topViewBGImg.removeGestureRecognizer(self.swipeDownGesture!)
    }
    
    func addSwipeGestureOnSearchBarContainer()
    {
        self.swipeUpGesture?.addTarget(self, action: #selector(MyDashBoardViewController.searchContainerSwipeUp(sender:)))
        self.universalSearchContainerView.addGestureRecognizer(self.swipeUpGesture!)
    }
    
    func removeSwipeGestureFromSearchContainer()
    {
        self.swipeUpGesture?.removeTarget(self, action: #selector(MyDashBoardViewController.searchContainerSwipeUp(sender:)))
        self.universalSearchContainerView.removeGestureRecognizer(self.swipeUpGesture!)
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
            self.showSearchBar()
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
    
    func searchContainerSwipeUp(sender:UISwipeGestureRecognizer){
        self.hideSearchBar()
    }
    
    //MARK:- Searchbar Utilities
    override func hideSearchBar()
    {
        self.universalSearchBar.resignFirstResponder()
        self.removeSwipeGestureFromSearchContainer()
        self.addSwipeGestureOnDashboard()
        self.universalSearchContainerView.isHidden = true
        
        self.searchBarTop.constant = -44
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func showSearchBar()
    {
        self.removeSwipeGestureFromDashBoard()
        self.addSwipeGestureOnSearchBarContainer()
        self.universalSearchContainerView.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            
            self.searchBarTop.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }, completion: {(isCompleted) -> Void in
            self.universalSearchBar.becomeFirstResponder()
        })
    }
    
    // MARK: - IBOutlet Actions
    @IBAction func notificationAction(_ sender: AnyObject) {
        
        self.notificationBtn.alpha = 1.0
        self.hypBtn.alpha = 0.25
        self.tournamentsBtn.alpha = 0.25
        currentButtonIndex = 0
        self.tableView.reloadData()
        
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
    
    //MARK:- Service Calls for data
    
    func getUserProfileData(){
        
        //On success
        let success: successHandler = {responseObject, responseType in
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            self.isResponseReceived = true
            if responseType == RequestedUrlType.GetUserProfileData {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "hypes") as? NSArray
                {
                    self.hypetoShowArray = NSMutableArray.init(array: array)
                    let limit:NSInteger = HYPE_PAGE_LIMIT
                    if self.hypetoShowArray.count < limit {
                        self.isHypeLoadMore = false
                    }else
                    {
                        self.isHypeLoadMore = true
                        self.hypePageIndex = 1
                    }
                    
                }
                //initialize tournament list
                if let array:NSArray =  responseDict.object(forKey: "upcoming") as? NSArray
                {
                    self.tournamentsToShowArray = NSMutableArray.init(array: array)
                    if self.tournamentsToShowArray.count < PAGE_SIZE {
                        self.isTournamentLoadMore = false
                    }else
                    {
                        self.isTournamentLoadMore = true
                        self.tournamentPageIndex = 1
                    }
                }
                
                //Parse User Data
                self.parseUserInfo(userInfo: responseDict.object(forKey: "person") as! NSDictionary)
                
            }else if responseType == RequestedUrlType.GetNotificationList
            {
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    self.notificationToShowArray = NSMutableArray.init(array: array)
                    if self.notificationToShowArray.count < PAGE_SIZE {
                        self.isNotificationLoadMore = false
                    }else
                    {
                        self.isNotificationLoadMore = true
                        self.notificationPageIndex = 1
                    }
                }
            }
            self.tableView.reloadData()
            self.hideHUD()
            
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.isResponseReceived = true
            self.hideHUD()
            print(responseString)
        }
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetUserProfileData, method: "GET", successCall: success, falureCall: failure)
        
        // Service call for notifications
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetNotificationList, method: "GET", successCall: success, falureCall: failure)
        
    }
    
    func getTournaments() {
        //On success
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            if responseType == RequestedUrlType.GetCurrentAndUpcomingTournament {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    if array.count < PAGE_SIZE {
                        self.isTournamentLoadMore = false
                    }else
                    {
                        self.isTournamentLoadMore = true
                    }
                    self.tournamentsToShowArray.addObjects(from: array as! [Any])
                    self.tableView.reloadData()
                }
                
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue(self.userProfileInfo.stringValueForKey(key: "userID"), forKey: "userID")
        requestDict.setValue("\(self.tournamentPageIndex)", forKey: "pagenumber")
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetCurrentAndUpcomingTournament, method: "GET", successCall: success, falureCall: failure)
    }
    
    func getNotifications() {
        //On success
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            if responseType == RequestedUrlType.GetNotificationList {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    if array.count < PAGE_SIZE {
                        self.isNotificationLoadMore = false
                    }else
                    {
                        self.isNotificationLoadMore = true
                    }
                    self.notificationToShowArray.addObjects(from: array as! [Any])
                    self.tableView.reloadData()
                }
                
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue("", forKey: "deviceToken")
        requestDict.setValue("\(self.notificationPageIndex)", forKey: "pagenumber")
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetNotificationList, method: "GET", successCall: success, falureCall: failure)
    }
    
    func getHypeTournaments() {
        //On success
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            if responseType == RequestedUrlType.HypeSearch {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    let limit:NSInteger = HYPE_PAGE_LIMIT
                    if array.count < limit {
                        self.isHypeLoadMore = false
                    }else
                    {
                        self.isHypeLoadMore = true
                    }
                    self.hypetoShowArray.addObjects(from: array as! [Any])
                    self.tableView.reloadData()
                }
                
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        let requestDict:NSMutableDictionary = NSMutableDictionary()
        requestDict.setValue("\(self.hypePageIndex)", forKey: "pagenumber")
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.HypeSearch, method: "GET", successCall: success, falureCall: failure)
    }
    
    //MARK:- ScrollView Delegates
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.universalSearchTableView
        {
            super.scrollViewDidEndDecelerating(scrollView)
        }else
        {
            if commonSetting.isInternetAvailable {
                if currentButtonIndex == 1 || currentButtonIndex == 2 {
                    var endScrolling = 0
                    var dimension = 0
                    
                    if IS_IPHONE {
                        endScrolling = Int(scrollView.contentOffset.y) + Int(scrollView.frame.size.height)
                        dimension = Int(scrollView.contentSize.height)
                    }else
                    {
                        endScrolling = Int(scrollView.contentOffset.x) + Int(scrollView.frame.size.width)
                        dimension = Int(scrollView.contentSize.width)
                    }
                    
                    if endScrolling >= dimension {
                        
                        if currentButtonIndex == 2 && self.isTournamentLoadMore {
                            self.tournamentPageIndex += 1
                            self.isTournamentLoadMore = false
                            self.getTournaments()
                        }else if currentButtonIndex == 1 && self.isHypeLoadMore
                        {
                            self.hypePageIndex += 1
                            self.isHypeLoadMore = false
                            self.getHypeTournaments()
                        }
                    }
                }else
                {
                    var endScrolling = 0
                    var dimension = 0
                    
                    endScrolling = Int(scrollView.contentOffset.y) + Int(scrollView.frame.size.height)
                    dimension = Int(scrollView.contentSize.height)
                    
                    if endScrolling >= dimension {
                        
                        if  self.isNotificationLoadMore {
                            self.notificationPageIndex += 1
                            self.isNotificationLoadMore = false
                            self.getNotifications()
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - TableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.universalSearchTableView {
            return super.numberOfSections(in: tableView)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.universalSearchTableView {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }else
        {
            var count:Int = 0
            if currentButtonIndex == 0 {
                count = notificationToShowArray.count
                
            }else if currentButtonIndex == 1
            {
                count = hypetoShowArray.count
                
            }else if currentButtonIndex == 2
            {
                count = tournamentsToShowArray.count
            }
            
            if count == 0{
                let noDataLabel:UILabel  = UILabel.init(frame: CGRect(x:0,y:0,width:tableView.bounds.size.width,height:tableView.bounds.size.height))
                if self.isResponseReceived {
                    noDataLabel.text = "No data available"
                }else
                {
                    noDataLabel.text = "Loading..."
                }
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = NSTextAlignment.center
                tableView.backgroundView = noDataLabel
            }
            else{
                tableView.backgroundView   = nil
            }
            return count
        }
    }
    
    
    // create a cell for each table view row
    override func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        if tableView == self.universalSearchTableView {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }else
        {
            let cell:UITableViewCell
            if currentButtonIndex == 0 {
                
                cell = self.configureNotificationCell(tableView: tableView, indexPath: indexPath)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                
            }else if currentButtonIndex == 1
            {
                cell = self.configureHypeCell(tableView: tableView, indexPath: indexPath)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                
            }else
            {
                cell = self.configureTournamentCell(tableView: tableView, indexPath: indexPath)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            tableView.separatorColor = UIColor.darkGray
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.universalSearchTableView {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }else
        {
            if (currentButtonIndex == 0) {
                return UITableViewAutomaticDimension
            }
            else{
                return 139.0
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.universalSearchTableView {
            return super.tableView(tableView, didSelectRowAt: indexPath)
        }else
        {
            if self.currentButtonIndex == 2{
                let tournament:NSDictionary = self.tournamentsToShowArray.object(at: indexPath.row) as! NSDictionary
                let tournId:Int = tournament.intValueForKey(key: "tournamentID")
                self.getTournamentById(tournamentID: tournId)
            }
        }
    }
    
    func  configureHypeCell(tableView:UITableView, indexPath:IndexPath) -> HypeTableViewCell {
        
        let cell:HypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HypeTableViewCell", for: indexPath) as! HypeTableViewCell
        
        let hypeInfo:NSDictionary = self.parseResponse(responseObject: hypetoShowArray.object(at: indexPath.row))
        
        // Set Border Image
        if hypeInfo.stringValueForKey(key: "hypableType") == "TOURNAMENT" {
            cell.hypeBorderImg.image = UIImage(named: "HypeImageBorder")
        }else
        {
            cell.hypeBorderImg.image = UIImage(named: "EventCellHyped")
        }
        cell.hypeBgImg.image = nil
        
        cell.hypNameLbl.text = hypeInfo.stringValueForKey(key: "name").uppercased()
        cell.gameLbl.text = hypeInfo.stringValueForKey(key: "game").uppercased()
        cell.locationLbl.text = hypeInfo.stringValueForKey(key: "venue").uppercased()
        cell.dateLbl.text = self.getLocaleDateStringFromString(dateString: hypeInfo.stringValueForKey(key: "startDate"))
        
        //Set Default Image
        self.setDefaultImages(cell: cell, indexPath: indexPath)
        
        //Download Image
        let imageKey = hypeInfo.stringValueForKey(key: "imageKey")
        
        let sucess:downloadImageSuccess = {image, imageKey in
            
            cell.hypeBgImg.image = image
            cell.progressBar.stopAnimating()
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            cell.progressBar.stopAnimating()
        }
        
        if imageKey != "" {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }
        return cell
    }
    
    
    func  configureTournamentCell(tableView:UITableView, indexPath:IndexPath) -> HypeTableViewCell {
        
        let cell:HypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HypeTableViewCell", for: indexPath) as! HypeTableViewCell
        
        let tournaInfo:NSDictionary = self.parseResponse(responseObject: tournamentsToShowArray.object(at: indexPath.row))
        
        let val = tournaInfo.value(forKey: "hype") as! NSNumber
        if val == 0 {
            cell.hypeBorderImg.image = UIImage(named: "ImageBorder")
        }else
        {
            cell.hypeBorderImg.image = UIImage(named: "HypeImageBorder")
        }
        cell.hypeBorderImg.image = UIImage(named: "ImageBorder")
        cell.hypeBgImg.image = nil
        cell.hypNameLbl.text = tournaInfo.stringValueForKey(key: "name").uppercased()
        cell.gameLbl.text = tournaInfo.stringValueForKey(key: "game").uppercased()
        cell.locationLbl.text = tournaInfo.stringValueForKey(key: "venue").uppercased()
        cell.dateLbl.text = self.getFormattedDateString(info: tournaInfo, indexPath: indexPath, format: "yyyy")
        
        //Set Default Image
        self.setDefaultImages(cell: cell, indexPath: indexPath)
        
        //Download Image
        let imageKey = tournaInfo.stringValueForKey(key: "imageKey")

        let sucess:downloadImageSuccess = {image, imageKey in
            
            cell.hypeBgImg.image = image
            cell.progressBar.stopAnimating()
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            cell.progressBar.stopAnimating()
        }
        
        if imageKey != "" {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imageKey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }
        
        return cell
    }
    
    func  configureNotificationCell(tableView:UITableView, indexPath:IndexPath) -> NotificationTableViewCell {
        
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        let notificationInfo:NSDictionary = self.parseResponse(responseObject: notificationToShowArray.object(at: indexPath.row))
        
        var message:String = notificationInfo.stringValueForKey(key: "notificationHeader")
        
        let receivedDate:Date = self.getLocaleDateFromString(dateString: notificationInfo.value(forKey: "date") as! String)
        let timeDifference:String = NSDate.getTimeDiff(since: receivedDate)
        if !timeDifference.isEmpty
        {
            message = message.appendingFormat("  %@", timeDifference)
        }
        
        var fontForHeader:UIFont = StyleGuide.fontFutaraRegular(withFontSize: 16)
        if IS_IPAD {
            fontForHeader = StyleGuide.fontFutaraRegular(withFontSize: 21)
        }
        
        var fontForHeighlight:UIFont = StyleGuide.fontFutaraBold(withFontSize: 14)
        if IS_IPAD {
            fontForHeighlight = StyleGuide.fontFutaraBold(withFontSize: 18)
        }
        
        let attributesForHeaderString:[String : Any] = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName : fontForHeader]
        var attributedStringMessage = NSMutableAttributedString(string: message, attributes: attributesForHeaderString)
        
        let map:NSDictionary = self.parseResponse(responseObject: notificationInfo.value(forKey: "map") as Any)
        
        if let userInfoArr:NSArray = map.value(forKey: "userinfo") as? NSArray
        {
            for dictionary:NSDictionary in userInfoArr as! [NSDictionary]{
                
                if !dictionary.stringValueForKey(key: "name").isEmpty {
                    var name = dictionary.stringValueForKey(key: "name")
                    message = message.replacingOccurrences(of: name, with: String.init(format: "@%@", name))
                    name = String.init(format: "@%@", name)
                    let range = (message as NSString).range(of:name)
                    
                    attributedStringMessage = NSMutableAttributedString(string: message, attributes: attributesForHeaderString)
                    attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
                    attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
                    attributedStringMessage.addAttribute("clickOnUser", value: true, range: range)
                }
            }
        }
        
        if let tournamentInfoArr:NSArray = map.value(forKey: "tournamentinfo") as? NSArray
        {
            for dictionary:NSDictionary in tournamentInfoArr as! [NSDictionary]{
                if !dictionary.stringValueForKey(key: "name").isEmpty {
                    let name = dictionary.stringValueForKey(key: "name")
                    let range = (message as NSString).range(of:name)
                    attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
                    attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
                    attributedStringMessage.addAttribute("clickOnTournament", value: true, range: range)
                }
            }
        }
        
        if let seasonInfoArr:NSArray = map.value(forKey: "seasoninfo") as? NSArray
        {
            for dictionary:NSDictionary in seasonInfoArr as! [NSDictionary]{
                if !dictionary.stringValueForKey(key: "name").isEmpty {
                    let name = dictionary.stringValueForKey(key: "name")
                    let range = (message as NSString).range(of:name)
                    attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
                    attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
                    attributedStringMessage.addAttribute("clickOnSeason", value: true, range: range)
                }
            }
        }
        
        if let eventInfoArr:NSArray = map.value(forKey: "eventinfo") as? NSArray
        {
            for dictionary:NSDictionary in eventInfoArr as! [NSDictionary]{
                if !dictionary.stringValueForKey(key: "name").isEmpty {
                    let name = dictionary.stringValueForKey(key: "name")
                    let range = (message as NSString).range(of:name)
                    attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: kLightBlueColor , range: range)
                    attributedStringMessage.addAttribute(NSFontAttributeName, value: fontForHeighlight, range: range)
                    attributedStringMessage.addAttribute("clickOnEvent", value: true, range: range)
                }
                
            }
        }
        
        if !timeDifference.isEmpty {
            
            let range = (message as NSString).range(of:timeDifference)
            attributedStringMessage.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: range)
            attributedStringMessage.addAttribute(NSFontAttributeName, value: StyleGuide.fontFutaraRegular(withFontSize: 10), range: range)
        }
        
        cell.notificationTextView.text = nil
        cell.notificationTextView.attributedText = nil
        cell.notificationTextView.attributedText = attributedStringMessage
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(MyDashBoardViewController.textTapped(recognizer:)))
        cell.notificationTextView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func textTapped(recognizer:UITapGestureRecognizer) {
        
        let textView:UITextView = recognizer.view as! UITextView
        
        // Location of the tap in text-container coordinates
        let layoutManager:NSLayoutManager = textView.layoutManager
        var location:CGPoint = recognizer.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        // Find the character that's been tapped on
        let characterIndex:Int = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textView.textStorage.length {
            
            var range:NSRange? = NSMakeRange(0, 1)
            if let value:Bool = textView.attributedText.attribute("clickOnUser", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on user")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnTournament", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Tournament")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnSeason", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Season")
            }
            if let value:Bool = textView.attributedText.attribute("clickOnEvent", at: characterIndex, effectiveRange: &range!) as! Bool?
            {
                self.showAlert(title: kMessage, message: "Tapped on Event")
            }
        }
    }
    
    func getNotificationMapInfo(notification:NSDictionary, key:String) -> NSDictionary {
        if let tournamentInfo:NSArray = notification.value(forKey: key) as? NSArray
        {
            let dictionary:NSDictionary = self.parseResponse(responseObject: tournamentInfo.firstObject as Any)
            return dictionary
        }
        return NSDictionary()
    }
    
}
