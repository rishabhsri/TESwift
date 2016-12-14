//
//  SocialConnectViewController.swift
//  TESwift
//
//  Created by Rajanikant Shukla on 14/12/16.
//  Copyright © 2016 V group Inc. All rights reserved.
//

import UIKit

class SocialConnectViewController: BaseViewController,UIWebViewDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - IBAction Methods
    
    @IBAction func actionOnClose(_ sender: Any) {
    }
    
    @IBAction func actionOnBack(_ sender: Any) {
    }

    @IBAction func actionOnRefresh(_ sender: Any) {
    }

    @IBAction func actionOnForward(_ sender: Any) {
    }
    
    //MARK:- Social Connect handlers
    
    @IBAction func socialLoginViaFacebook(_ sender: Any) {
    }
    
    @IBAction func socialLoginViaGooglePlus(_ sender: Any) {
    }
    
    @IBAction func socialLoginViaTwitch(_ sender: Any) {
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
