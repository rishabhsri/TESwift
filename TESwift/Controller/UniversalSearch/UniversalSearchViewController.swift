//
//  UniversalSearchViewController.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 22/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class UniversalSearchViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var universalSearchBar: UISearchBar!
    @IBOutlet weak var universalSearchTableView: UITableView!
    @IBOutlet weak var universalSearchContainerView: UIView!
    
    var pageNumber:NSInteger = 0
    var isSearchEnabled:Bool = false
    var isLoadMoreSearch:Bool = false
    
    var persons:NSArray = NSArray()
    var tournaments:NSArray = NSArray()
    var seasons:NSArray = NSArray()
    var events:NSArray = NSArray()
    var teams:NSArray = NSArray()
    
    var keys:[String] = [String]()
    var items:NSMutableDictionary = NSMutableDictionary()
    var searchResults:NSMutableArray = NSMutableArray()
    
    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUniversalSearchBar()
        
        self.universalSearchTableView.tableFooterView = UIView()
        
        self.searchResults = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- ScrollView Delegates
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if COMMON_SETTING.isInternetAvailable {
            var endScrolling = 0
            var dimension = 0
            
            endScrolling = Int(scrollView.contentOffset.y) + Int(scrollView.frame.size.height)
            dimension = Int(scrollView.contentSize.height)
            
            if endScrolling >= dimension {
                
                if  self.isLoadMoreSearch {
                    self.pageNumber += 1
                    self.isLoadMoreSearch = false
                    self.filterSearchForText(searchText: self.universalSearchBar.text!)
                }
            }
        }
    }
    
    //MARK:- Unversal Search Configuration
    
    func filterSearchForText(searchText:String) {
        
        let success: searchSuccessHandler = {responseObject, responseType in
            
            self.hideHUD()
            if self.pageNumber == 0
            {
                self.searchResults.removeAllObjects()
            }
            
            let responseDict = serviceCall.parseResponse(responseObject: responseObject as Any)
            
            if let responseObjects:NSArray = responseDict.value(forKey: "docs") as? NSArray {
                if responseObjects.count < PAGE_SIZE
                {
                    self.isLoadMoreSearch = false
                }else
                {
                    self.isLoadMoreSearch = true
                }
                
                self.searchResults.addObjects(from: responseObjects as! [Any])
                
                if self.searchResults.count > 0 {
                    self.parseSearchResult(result: self.searchResults)
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
        ServiceCall.sharedInstance.sendSearchRequest(searchText: searchText, urlType: .UniversalSearch, pageNumber: "\(self.pageNumber)", successCall: success, falureCall: failure)
    }
    
    func configureUniversalSearchBar()
    {
        self.universalSearchBar.placeholder = "SEARCH                        "
        self.universalSearchBar.backgroundColor = UIColor.clear
        self.universalSearchBar.keyboardAppearance = .alert
        self.universalSearchBar.backgroundImage = UIImage()
        if IS_IPHONE {
            self.universalSearchBar.isTranslucent = true
        }else
        {
            self.universalSearchBar.isTranslucent = false
            self.universalSearchBar.barTintColor = kSearchBarBarTintColor
        }
        self.universalSearchBar?.tintColor = kSearchBarTintColor
        
        if let txfSearchField:UITextField = self.universalSearchBar.value(forKey: "_searchField") as? UITextField
        {
            txfSearchField.backgroundColor = kSearchBarBackgroundColor
            txfSearchField.textColor = kSearchBartextColor
            txfSearchField.attributedPlaceholder = NSAttributedString.init(string: "SEARCH                        ", attributes: [NSFontAttributeName:StyleGuide.fontFutaraRegular(withFontSize: 12)])
            //txfSearchField.delegate = self
        }
        
        self.universalSearchBar.showsCancelButton = true
        
    }
    
    //MARK:- Parser
    
    func parseSearchResult(result:NSMutableArray)
    {
        self.items = NSMutableDictionary()
        
        self.persons = NSArray.init(array: result.filtered(using: NSPredicate(format: "doc_id BEGINSWITH[c] %@", "Person")))
        self.tournaments = NSArray.init(array: result.filtered(using: NSPredicate(format: "doc_id BEGINSWITH[c] %@", "Tournament")))
        self.seasons = NSArray.init(array: result.filtered(using: NSPredicate(format: "doc_id BEGINSWITH[c] %@", "Season")))
        self.events = NSArray.init(array: result.filtered(using: NSPredicate(format: "doc_id BEGINSWITH[c] %@", "Event")))
        self.teams = NSArray.init(array: result.filtered(using: NSPredicate(format: "doc_id BEGINSWITH[c] %@", "Team")))
        
        self.items.setValue(self.tournaments, forKey: "Tournaments")
        self.items.setValue(self.events, forKey: "Events")
        self.items.setValue(self.seasons, forKey: "Seasons")
        self.items.setValue(self.teams, forKey: "Teams")
        self.items.setValue(self.persons, forKey: "Persons")
        
        self.keys = ["Persons","Tournaments","Seasons","Events","Teams"]
    }
    
    //MARK:- UITableView Delegates and Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.objectsCountInSection(section: section)
    }
    
    func objectsCountInSection(section:Int) -> Int {
        if self.keys.count > 0
        {
            let key:String = self.keys[section]
            if let array:NSArray = self.items.value(forKey: key) as! NSArray? {
                return array.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.objectsCountInSection(section: section) == 0 {
            return 0.01
        }
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.objectsCountInSection(section: section) == 0 {
            return nil
        }
        let customView:UIView = UIView.init(frame: CGRect(x:10,y:0,width:tableView.frame.size.width,height:40))
        customView.backgroundColor = UIColor.darkGray
        
        let headerLabel:UILabel = UILabel()
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.isOpaque = false
        headerLabel.textColor = UIColor.white
        headerLabel.highlightedTextColor = UIColor.white
        
        headerLabel.font = StyleGuide.fontFutaraRegular(withFontSize: IS_IPHONE ? 16 : 19)
        headerLabel.frame = CGRect(x:10,y:5,width:tableView.frame.size.width-30,height:30)
        headerLabel.text = self.keys[section]
        
        customView.addSubview(headerLabel)
        
        return customView;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchTableViewCell
        var name:String = ""
        let key:String = self.keys[indexPath.section]
        if let array:NSArray = self.items.value(forKey: key) as! NSArray? {
            if let dict:NSDictionary = array.object(at: indexPath.row) as? NSDictionary
            {
                name = dict.stringValueForKey(key: "name")
            }
        }
        cell.lblTitle.text = name.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let key:String = self.keys[indexPath.section]
        if let array:NSArray = self.items.value(forKey: key) as! NSArray? {
            if let dict:NSDictionary = array.object(at: indexPath.row) as? NSDictionary
            {
                let id:String = dict.stringValueForKey(key: "id")
                let name:String = dict.stringValueForKey(key: "name")
                if key == "Tournaments"
                {
                    self.showAlert(title: "", message: "Tournament : \(name)")
                }else if key == "Seasons"
                {
                    self.showAlert(title: "", message: "Season : \(name)")
                }else if key == "Events"
                {
                    self.showAlert(title: "", message: "Event : \(name)")
                }else if key == "Teams"
                {
                    self.showAlert(title: "", message: "Team : \(name)")
                }else if key == "Persons"
                {
                    self.showAlert(title: "", message: "Person : \(name)")
                }
            }
        }
    }
    
    
    //MARK:- SearchBar Delegates
    
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
            self.pageNumber = 0
            self.filterSearchForText(searchText: searchText)
        }else{
            self.hideTableData()
            ServiceCall.sharedInstance.cancleAllSearchRequests()
        }
    }
    
    func hideTableData() {
        self.isSearchEnabled = false
        self.searchResults.removeAllObjects()
        self.universalSearchTableView.reloadData()
        self.universalSearchTableView.isHidden = true
    }
    
    func showTableData() {
        self.isSearchEnabled = true
        self.universalSearchTableView.reloadData()
        self.universalSearchTableView.isHidden = false
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.universalSearchBar.resignFirstResponder()
    }// called when keyboard search button pressed
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.universalSearchBar.resignFirstResponder()
        self.universalSearchBar.text = ""
        self.hideTableData()
        self.hideSearchBar()
        
    }// called when cancel button pressed
    
    
    //MARK:- Searchbar Utilities
    func hideSearchBar()
    {
        //overrided in child
    }
    
    func showSearchBar()
    {
        //overrided in child
    }
    
}
