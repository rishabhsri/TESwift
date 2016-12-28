//
//  TournamentListViewController.swift
//  TESwift
//
//  Created by Apple on 23/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class TournamentListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, SWTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tounamentEmptyView: UIView!
    @IBOutlet weak var navigationBlurView: UIVisualEffectView!
    
    @IBOutlet weak var tournamentTitleLbl: UILabel!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    @IBOutlet weak var plusIcon: UIButton!
    
    // SearchBar outlet
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    
    var swipeDownGesture:UISwipeGestureRecognizer?
    var swipeUpGesture:UISwipeGestureRecognizer?
    
    var pageNumberForTournament:NSInteger = 0
    var pageNumberForSearchTournament:NSInteger = 0
    var isSearchEnabled:Bool = false
    var isLoadMoreSearch:Bool = false
    var isLoadMoreTournament:Bool = false
    var searchResults:NSMutableArray = NSMutableArray()
    
    
    //class Variables
    var tournamentsArray:NSMutableArray = NSMutableArray()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStyleGuide()
        
        self.getUsersTournament()
        
        self.setupMenu()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStyleGuide()
    {
        self.tableView.contentInset = UIEdgeInsets(top: 65,left: 0,bottom: 0,right: 0)
        self.tounamentEmptyView.isHidden = true
        self.toolBar.frame = CGRect.init(x: 0, y: 0, width: 320, height: 70)
        self.configureSearchBar()
        self.configureSwipeGesture()
    }
    
    func  configureSwipeGesture() {
        self.swipeDownGesture = UISwipeGestureRecognizer()
        self.swipeUpGesture = UISwipeGestureRecognizer()
        
        swipeDownGesture?.direction = UISwipeGestureRecognizerDirection.down
        swipeUpGesture?.direction = UISwipeGestureRecognizerDirection.up
        
        self.swipeDownGesture?.addTarget(self, action: #selector(TournamentListViewController.swipeDownHandler(sender:)))
        self.swipeUpGesture?.addTarget(self, action: #selector(TournamentListViewController.swipeUpHandler(sender:)))
        
        self.tableView.addGestureRecognizer(swipeDownGesture!)
    }
    
    func removeSwipeGesture()
    {
        self.swipeDownGesture?.removeTarget(self, action: #selector(TournamentListViewController.swipeDownHandler(sender:)))
        self.tableView.removeGestureRecognizer(self.swipeDownGesture!)
    }
    
    // MARK:- IBAction
    
    @IBAction func actionOnSearchButton(_ sender: AnyObject) {
        self.showSearchBar()
    }
    
    @IBAction func actionOnPlusIcon(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Storyboard", bundle: nil)
        let tournamentListVC:UIViewController = storyBoard.instantiateViewController(withIdentifier: "CreateTournamentViewControllerID")
        self.navigationController?.pushViewController(tournamentListVC, animated: true)
    }
    
    // MARK:- Uitlity
    
    func swipeDownHandler(sender:UISwipeGestureRecognizer){
        self.showSearchBar()
    }
    
    func swipeUpHandler(sender:UISwipeGestureRecognizer){
        //self.hideSearchBar()
    }
    
    func showSearchBar() {
        // self.removeSwipeGesture()
        self.searchBar.becomeFirstResponder()
        self.searchView.isHidden = false
        self.searchBar.isHidden = false
        self.toolBar.isHidden = false
        self.menuButton.isHidden = true
        self.searchBtnOutlet.isHidden = true
        self.plusIcon.isHidden = true
        self.tableView.alpha = 0.5
        self.tournamentTitleLbl.isHidden = true
    }
    
    func hideSearchBar()
    {
        self.searchBar.resignFirstResponder()
        self.searchView.isHidden = true
        self.searchBar.isHidden = true
        self.toolBar.isHidden = true
        self.menuButton.isHidden = false
        self.searchBtnOutlet.isHidden = false
        self.plusIcon.isHidden = false

        self.tableView.alpha = 1.0
        self.tournamentTitleLbl.isHidden = false
        self.searchBar.text = ""
        
    }
    
    func hideTableData() {
        self.isSearchEnabled = false
        self.searchResults.removeAllObjects()
        self.tableView.reloadData()
    }
    
    func showTableData() {
        self.isSearchEnabled = true
        self.tableView.reloadData()
    }
    
    
    func configureSearchBar()
    {
        self.searchBar.placeholder = "SEARCH                        "
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.keyboardAppearance = .alert
        self.searchBar.backgroundImage = UIImage()
        if IS_IPHONE {
            self.searchBar.isTranslucent = true
        }else
        {
            self.searchBar.isTranslucent = false
            self.searchBar.barTintColor = kSearchBarBarTintColor
        }
        self.searchBar?.tintColor = kSearchBarTintColor
        
        if let txfSearchField:UITextField = self.searchBar.value(forKey: "_searchField") as? UITextField
        {
            txfSearchField.backgroundColor = kSearchBarBackgroundColor
            txfSearchField.textColor = kSearchBartextColor
            txfSearchField.attributedPlaceholder = NSAttributedString.init(string: "SEARCH                        ", attributes: [NSFontAttributeName:StyleGuide.fontFutaraRegular(withFontSize: 12)])
            //txfSearchField.delegate = self
        }
        
        self.searchBar.showsCancelButton = true
        
    }
    
    func getUsersTournament()
    {
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            print(responseDict)
            if let array:NSArray = responseDict.object(forKey: "list") as? NSArray
            {
                self.tournamentsArray = NSMutableArray.init(array: array)
                self.tableView.reloadData()
            }
        }
        let failure: falureHandler = {error, responseString, responseType in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        ServiceCall.sharedInstance.sendRequest(parameters: NSMutableDictionary(), urlType: RequestedUrlType.GetUsersTournament, method: "GET", successCall: success, falureCall: failure)
    }
    
    func loadMoreTournament() {
        
        let success: successHandler = {responseObject, responseType in
            
            self.hideHUD()
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            if responseType == RequestedUrlType.GetUsersTournament {
                
                //initialize hype list
                if let array:NSArray =  responseDict.object(forKey: "list") as? NSArray
                {
                    if array.count < PAGE_SIZE {
                        self.isLoadMoreTournament = false
                    }else
                    {
                        self.isLoadMoreTournament = true
                    }
                    
                    for task in array {
                        self.tournamentsArray.add(task)
                    }
                    // self.tournamentsArray.addObjects(from: array as! [Any])
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
        requestDict.setValue("\(self.pageNumberForTournament)", forKey: "pagenumber")
        
        // Service call for get user profile data (Hypes, upcomings, person, followers)
        ServiceCall.sharedInstance.sendRequest(parameters: requestDict, urlType: RequestedUrlType.GetUsersTournament, method: "GET", successCall: success, falureCall: failure)
    }
    
    
    //MARK: - SearchBar Delegate
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.isSearchEnabled = true
        self.isLoadMoreSearch = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.characters.count)! >= 2{
            self.pageNumberForSearchTournament = 0
            self.filterTournamentSearchForText(searchText: searchText)
        }else{
            self.hideTableData()
            ServiceCall.sharedInstance.cancleAllSearchRequests()
        }
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }// called when keyboard search button pressed
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.hideTableData()
        self.hideSearchBar()
    }// called when cancel button pressed
    
    
    //MARK:- ScrollView Delegates
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if commonSetting.isInternetAvailable {
            var endScrolling = 0
            var dimension = 0
            
            endScrolling = Int(scrollView.contentOffset.y) + Int(scrollView.frame.size.height)
            dimension = Int(scrollView.contentSize.height)
            
            if endScrolling >= dimension {
                
                if  self.isLoadMoreSearch {
                    self.pageNumberForSearchTournament += 1
                    self.isLoadMoreSearch = false
                    self.filterTournamentSearchForText(searchText: self.searchBar.text!)
                }else
                {
                    self.pageNumberForTournament += 1
                    self.isLoadMoreTournament = false
                    self.loadMoreTournament()
                }
            }
        }
    }
    
    
    // MARK:- Tournament search
    
    func filterTournamentSearchForText(searchText:String) {
        
        let success: searchSuccessHandler = {responseObject, responseType in
            
            self.hideHUD()
            if self.pageNumberForSearchTournament == 0
            {
                self.searchResults.removeAllObjects()
            }
            
            let responseDict = self.parseResponse(responseObject: responseObject as Any)
            
            if let responseObjects:NSArray = responseDict.value(forKey: "list") as? NSArray {
                if responseObjects.count < PAGE_SIZE
                {
                    self.isLoadMoreSearch = false
                }else
                {
                    self.isLoadMoreSearch = true
                }
                
                for item in responseObjects {
                    self.searchResults.add(item)
                }
                //    self.searchResults.addObjects(from: responseObjects as! [Any])
                
                if self.searchResults.count > 0 {
                    // self.parseSearchResult(result: self.searchResults)
                    self.showTableData()
                }else
                {
                    self.hideTableData()
                }
            }
        }
        let failure: searchFalureHandler = {error, responseString, responseType in
            self.hideHUD()
            self.hideTableData()
        }
        self.showHUD()
        ServiceCall.sharedInstance.sendSearchRequest(searchText: searchText, urlType: RequestedUrlType.SearchTournament , pageNumber: "\(self.pageNumberForSearchTournament)", successCall: success, falureCall: failure)
    }
    
    
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchEnabled {
            return self.searchResults.count
        }
        return self.tournamentsArray.count
    }
    
    // create a cell for each table view row
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:TournamentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as! TournamentListTableViewCell
        
        let rightUtilityButton:NSMutableArray = NSMutableArray()
        rightUtilityButton.sw_addUtilityButton(with: StyleGuide.tableViewRightView(), icon: UIImage(named: "CloseCellPanel"))
        
        let leftUtilityButton:NSMutableArray = NSMutableArray()
        leftUtilityButton.sw_addUtilityButton(with: StyleGuide.tableViewRightView(), icon: UIImage(named: "HypeImage"))

        
        var tournaDict:NSDictionary = NSDictionary()
        
        if isSearchEnabled {
            tournaDict = self.parseResponse(responseObject: self.searchResults.object(at: indexPath.row))
        }else
        {
            tournaDict = self.parseResponse(responseObject: self.tournamentsArray.object(at: indexPath.row))
        }
        
        cell.backGroundImage.image = nil
        cell.tournmentName.text = tournaDict.stringValueForKey(key: "name").uppercased()
        cell.yearLabel.text = self.getFormattedDateString(info: tournaDict, indexPath: indexPath, format: "yyyy")
        
        self.setDefaultImages(cell: cell, indexPath: indexPath)
        
        let imagekey:String = tournaDict.stringValueForKey(key: "imageKey")
        weak var weakCell:TournamentListTableViewCell? = cell
        let sucess:downloadImageSuccess = {image, imageKey in
            
            weakCell!.backGroundImage.image = image
            weakCell!.progressBar.stopAnimating()
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            weakCell!.progressBar.stopAnimating()
        }
        
        if !commonSetting.isEmptySting(imagekey) {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }
       // let swiftAray:NSArray = rightUtilityButton as NSArray
        cell.rightUtilityButtons = rightUtilityButton.reversed()
        cell.leftUtilityButtons = leftUtilityButton.reversed()
        cell.delegate = self
        return cell
    }
    
    //MARK: - Swipable Table view cell delegate
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:
            print("Im pressed at right")
        default: break
            
        }
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerLeftUtilityButtonWith index: Int) {
        switch index {
        case 0:
            print("Im pressed at left")
        default: break
            
        }
    }
}



