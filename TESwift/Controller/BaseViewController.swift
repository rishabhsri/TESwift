//
//  BaseViewController.swift
//  TESwift
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{
    
    var context:NSManagedObjectContext? = nil
    var dateFormatter:DateFormatter? = nil
    var tap: UITapGestureRecognizer!
    var statusBarHidden:Bool = true
    typealias alertActionHandler = () -> Void
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    func manageObjectContext() -> NSManagedObjectContext {
        if context == nil {
            context = APP_DELEGATE.persistentContainer.viewContext
        }
        return context!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Utility methods
    func addDismisskeyboardTapGesture()->Void{
        
        if tap == nil{
            tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.handleTap(_:)))
        }
        self.view.addGestureRecognizer(tap)
    }
    
    func removeDismisskeyboardTapGesture()->Void {
        self.view.removeGestureRecognizer(tap)
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func showAlert(title: String, message: String) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String,actionHandler:@escaping alertActionHandler) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            actionHandler()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNoInternetAlert() -> Void {
        
        let alertController = UIAlertController(title: kError, message: kNoInternetConnect, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupMenu() -> Void
    {
        if  revealViewController() != nil {
            menuButton?.addTarget(revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            if DeviceType.IS_IPHONE_5
            {
                self.revealViewController().rearViewRevealWidth = 250
            }else
            {
                self.revealViewController().rearViewRevealWidth = 300
            }
            
            // view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setBlurImage(imageView:UIImageView,imageKey:String)
    {
        var image:UIImage?
        
        if let cachedImage:UIImage = ServiceCall.sharedInstance.getImageForKey(imageKey: imageKey)
        {
            image = cachedImage
        }else
        {
            let blurRadius:CGFloat = 80;
            let saturationDeltaFactor:CGFloat = 1.3;
            let tintColor:UIColor? = nil
            var tempimage:UIImage = imageView.image!
            
            let size:CGSize = CGSize(width:200, height:150)
            tempimage = tempimage.withImage(tempimage, scaledTo: size)
            image = UIImage.ty_imageByApplyingBlur(to: tempimage, withRadius: blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: nil)!
            
            ServiceCall.sharedInstance.saveImage(imageData: UIImagePNGRepresentation(image!)!, imageKey: imageKey)
        }
        
        imageView.image = image
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.opacity = 0.45
    }
    
    //MARK: Date Formatter
    func getLocaleDateFromString(dateString:String) -> Date {
        
        if self.dateFormatter == nil {
            self.dateFormatter = DateFormatter()
        }
        
        self.dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.dateFormatter?.timeZone = NSTimeZone(name:"GMT") as TimeZone!
        var finalDate:Date? = self.dateFormatter?.date(from: dateString)
        if finalDate == nil {
            self.dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.dateFormatter?.timeZone = NSTimeZone(name:"GMT") as TimeZone!
            finalDate = self.dateFormatter?.date(from: dateString)
        }
        return finalDate!
    }
    
    func getLocaleDateStringFromString(dateString:String) -> String {
        
        let receivedDate:Date = self.getLocaleDateFromString(dateString: dateString)
        let formatString:String = DateFormatter.dateFormat(fromTemplate: "ddMMy", options: 0, locale: NSLocale.current)!
        
        self.dateFormatter?.dateFormat = formatString
        self.dateFormatter?.locale = NSLocale.current
        self.dateFormatter?.timeZone = NSTimeZone.system
        
        if  let dateString:String = self.dateFormatter?.string(from: receivedDate)
        {
            return dateString
        }else
        {
            return " "
        }
    }
    
    func getFormattedDateString(array:NSArray,indexPath:IndexPath,format:String) -> String {
        
        var startKeyName:String = "startDateTime"
        var endKeyName:String = "endDateTime"
        
        let info:NSDictionary = array.object(at: indexPath.row) as! NSDictionary
        
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: startKeyName)) {
            startKeyName = "startDate"
        }
        if COMMON_SETTING.isEmptyStingOrWithBlankSpace(info.stringValueForKey(key: endKeyName)) {
            endKeyName = "endDate"
        }
        
        let targetStartDate:String = String.dateStringFromString(sourceString: info.stringValueForKey(key: startKeyName),format: format)
        let targetEndDate:String = String.dateStringFromString(sourceString:info.stringValueForKey(key: startKeyName),format:format)
        if targetEndDate == targetStartDate
        {
            return targetStartDate
        }else
        {
            return String.init(format: "%@ - %@", targetStartDate,targetEndDate)
        }
    }
    
    func getFormattedDateStringOfTournament(tournament:TETournamentList,format:String) -> String {
        
        let targetStartDate:String = String.dateStringFromString(sourceString: tournament.startDateTime!,format: format)
        let targetEndDate:String = String.dateStringFromString(sourceString:tournament.startDateTime!,format:format)
        if targetEndDate == targetStartDate
        {
            return targetStartDate
        }else
        {
            return String.init(format: "%@ - %@", targetStartDate,targetEndDate)
        }
    }
    
    
    //MARK: Sorters
    
    func sortArrayElements(inputArray:NSArray,key:String,isAscending:Bool) -> NSArray
    {
        let sortDiscriptor = NSSortDescriptor.init(key: "lastUpdatedAt", ascending: isAscending)
        let sortedArray = inputArray.sortedArray(using: [sortDiscriptor])
        
        return sortedArray as NSArray
    }
    
    // MARK:- Tournament Utilities
    
    func fetchTournamentMiniDetail(tournamentID:String)
    {
        let success: teHelper_Success_CallBack = {arrTournamentList in
            
            self.hideHUD()
            if let tournament:TETournamentList = arrTournamentList.firstObject as? TETournamentList
            {
                self.showTournamentDetailScreen(tournament: tournament)
            }
        }
        let failure: teHelper_Falure_CallBack = {error, responseString in
            self.hideHUD()
            print(responseString)
        }
        
        self.showHUD()
        
        TournamentHelper().getTournamentByID(tournamentID: tournamentID, success: success, failure: failure)
        
    }
    
    func showTournamentDetailScreen(tournament:TETournamentList)
    {
        //implementation
    }
    
    // MARK: - TextFields Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    //MARK:- HUD
    func showHUD() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
    }
    
    func hideHUD(){
        PKHUD.sharedHUD.hide()
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    //MARK:- Set Default Colors on Cell
    
    func setDefaultImages(cell:Any,indexPath:IndexPath) {
        
        let listColors:[String] = COMMON_SETTING.listViewColors
        if listColors.count == 0
        {
            return
        }
        
        if cell is HypeTableViewCell
        {
            let hypeTableCell:HypeTableViewCell = cell as! HypeTableViewCell
            hypeTableCell.colorString = listColors[indexPath.row%listColors.count]
            hypeTableCell.hypeBgImg.backgroundColor = UIColor.init(hexString: hypeTableCell.colorString!)
            
        }else if cell is TournamentListTableViewCell
        {
            let tournamentTableCell:TournamentListTableViewCell = cell as! TournamentListTableViewCell
            tournamentTableCell.colorString = listColors[indexPath.row%listColors.count]
            tournamentTableCell.backGroundImage.backgroundColor = UIColor.init(hexString: tournamentTableCell.colorString!)
        }
        
    }
}
