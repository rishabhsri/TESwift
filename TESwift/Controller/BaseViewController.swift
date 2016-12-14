//
//  BaseViewController.swift
//  TESwift
//
//  Created by Apple on 08/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate{
    
    var context:NSManagedObjectContext? = nil
    
    
    //MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func manageObjectContext() -> NSManagedObjectContext {
        
        if context == nil {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            context = appDelegate.persistentContainer.viewContext
            }
        return context!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Utility methods
    func addDismisskeyboardTapGesture()->Void{
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
    
    func showAlert(title: String, message: String,tag: NSInteger) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func parseResponse(responseObject:Any) -> NSDictionary {
        
        if let responseDict:NSDictionary = responseObject as? NSDictionary {
            return responseDict;
        }else if let responseString:String = responseObject as? String
        {
            return responseString.convertToDictionary(text: responseString)
        }
        return NSDictionary()
    }
    
    func setBlurImage(imageView:UIImageView) {
        
        let blurRadius:CGFloat = 80;
        let saturationDeltaFactor:CGFloat = 1.3;
        let tintColor:UIColor? = nil
        var tempimage:UIImage = imageView.image!
        
        let size:CGSize = CGSize(width:200, height:150)
        tempimage = tempimage.withImage(tempimage, scaledTo: size)
        let image:UIImage = UIImage.ty_imageByApplyingBlur(to: tempimage, withRadius: blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: nil)!
        imageView.image = image
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.opacity = 0.45
    }
}
