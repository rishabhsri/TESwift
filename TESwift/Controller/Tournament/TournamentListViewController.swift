//
//  TournamentListViewController.swift
//  TESwift
//
//  Created by Apple on 23/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class TournamentListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tounamentEmptyView: UIView!
    @IBOutlet weak var navigationBlurView: UIVisualEffectView!
    @IBOutlet weak var tournamentTitleLbl: UILabel!
    
    //class Variables
    var tournamentsArray:NSMutableArray = NSMutableArray()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStyleGuide()
        
        self.getUsersTournament()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStyleGuide() {
        self.tableView.contentInset = UIEdgeInsets(top: 60,left: 0,bottom: 0,right: 0)
        self.tounamentEmptyView.isHidden = true
    }
    
    // MARK:- Uitlity
    
    func getUsersTournament(){
        
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
    
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tournamentsArray.count
    }
    
    // create a cell for each table view row
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:TournamentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as! TournamentListTableViewCell
        let tournaDict:NSDictionary = self.parseResponse(responseObject: self.tournamentsArray.object(at: indexPath.row))
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
        
        return cell
    }
}



