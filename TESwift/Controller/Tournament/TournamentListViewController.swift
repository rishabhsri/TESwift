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
        
        self.setupMenu()
        
        self.getUsersTournament()
        
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
        let success: teHelper_Success_CallBack = {arrTournamentList in
            
            self.hideHUD()

            if arrTournamentList.count < PAGE_SIZE {
                self.isLoadMoreTournament = false
            }else
            {
                self.isLoadMoreTournament = true
            }
            
            COMMON_SETTING.myProfile?.addToTournament(NSSet(array:arrTournamentList as! [Any]))
            TETournamentList.save(self.manageObjectContext())
            
            self.updateTournamentList()
        }
        let failure: teHelper_Falure_CallBack = {error, responseString in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        TournamentHelper().getTournamentByUser(pageNumber: "\(self.pageNumberForTournament)", success: success, failure: failure)
        
    }
    
    func updateTournamentList()
    {
        let tournamentList:NSArray = NSArray.init(array: (COMMON_SETTING.myProfile?.tournament?.allObjects)!)
        
        let sortedArray = self.sortArrayElements(inputArray: tournamentList, key: "lastUpdatedAt", isAscending: false)
        
        self.tournamentsArray = NSMutableArray.init(array: sortedArray)
        
        self.tableView.reloadData()
    }
    
    
    func deleteTournamentForIndexPath(indexPath:IndexPath)
    {
        var tournaDict:NSDictionary = NSDictionary()
        if isSearchEnabled && self.searchResults.count>0
        {
            tournaDict = serviceCall.parseResponse(responseObject: self.searchResults.object(at: indexPath.row))
        }else
        {
            tournaDict = serviceCall.parseResponse(responseObject: self.tournamentsArray.object(at: indexPath.row))
        }
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
        
        if COMMON_SETTING.isInternetAvailable {
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
                    self.getUsersTournament()
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
            
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            
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

        
        var tournamentDetail:TETournamentList?
        
        if isSearchEnabled && self.searchResults.count>0
        {
//            tournaDict = serviceCall.parseResponse(responseObject: self.searchResults.object(at: indexPath.row))
//            cell.tournmentName.textColor = UIColor.lightGray
//            cell.yearLabel.textColor = UIColor.lightGray
//            cell.tournmentName.attributedText = StyleGuide.highlightedSearchedText(name: tournaDict.stringValueForKey(key: "name").uppercased(), searchedText: self.searchBar.text!)
        }else
        {
            tournamentDetail = self.tournamentsArray.object(at: indexPath.row) as? TETournamentList
            
            cell.tournmentName.textColor = UIColor.white
            cell.yearLabel.textColor = UIColor.white
            cell.tournmentName.attributedText = StyleGuide.highlightedSearchedText(name: (tournamentDetail?.tournamentName?.uppercased())!, searchedText: (tournamentDetail?.tournamentName?.uppercased())!)
        }
        
        cell.backGroundImage.image = nil
        cell.yearLabel.text = self.getFormattedDateStringOfTournament(tournament: tournamentDetail!, format: "yyyy")
        
        self.setDefaultImages(cell: cell, indexPath: indexPath)
        
        let imagekey:String = (tournamentDetail?.imageKay)!
        weak var weakCell:TournamentListTableViewCell? = cell
        let sucess:downloadImageSuccess = {image, imageKey in
            
            weakCell!.backGroundImage.image = image
            weakCell!.progressBar.stopAnimating()
        }
        
        let failure:downloadImageFailed = {error, responseString in
            
            weakCell!.progressBar.stopAnimating()
        }
        
        if !COMMON_SETTING.isEmptySting(imagekey) {
            cell.progressBar.startAnimating()
            ServiceCall.sharedInstance.downloadImage(imageKey: imagekey, urlType: RequestedUrlType.DownloadImage, successCall: sucess, falureCall: failure)
        }
        
       // let swiftAray:NSArray = rightUtilityButton as NSArray
        cell.rightUtilityButtons = rightUtilityButton.reversed()
        cell.leftUtilityButtons = leftUtilityButton.reversed()
        cell.delegate = self
        cell.hideUtilityButtons(animated: true)
        
        return cell
    }
    
    //MARK: - Swipable Table view cell delegate
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index
        {
        case 0:
            let selectedIndexPath:IndexPath = self.tableView.indexPath(for: cell)!
            self.deleteTournamentForIndexPath(indexPath: selectedIndexPath)
            break
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
    
    func swipeableTableViewCellShouldHideUtilityButtons(onSwipe cell: SWTableViewCell!) -> Bool {
        return true
    }
}



