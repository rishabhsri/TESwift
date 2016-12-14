//
//  SocialLoginViewController.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SocialLoginViewController: BaseViewController,UIWebViewDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var pwdButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func actionOnRefresh(_ sender: Any)
    {
    }
    
    @IBAction func actionOnStop(_ sender: Any)
    {
    }
    @IBAction func actionOnClose(_ sender: Any)
    {
    }
    
    //MARK:- Web View Delegates
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        
    }
    
    
    
}
