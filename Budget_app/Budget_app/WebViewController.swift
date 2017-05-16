//
//  WebViewController.swift
//  Budget_app
//
//  Created by app on 1/30/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webviewChat: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myTimer = Timer()
    var theBool = Bool()
    
    //Actions
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //override Functions
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        
        if let requestURL = (defaults.value(forKey: "WebViewURL")) as? String{
            activityIndicator.startAnimating()
            let request = NSURLRequest(url: (NSURL(string: requestURL)) as! URL)
            webviewChat.loadRequest(request as URLRequest)
        }
    }
    
    func timerCallback(){
        
        if theBool {
            if progressView.progress >= 1 {
                progressView.isHidden = true
                myTimer.invalidate()
            }else{
                progressView.progress += 0.1
            }
        }else{
            progressView.progress += 0.05
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
        progressView.progress = 0
        theBool = false
        myTimer =  Timer.scheduledTimer(timeInterval: 0.01667,target: self,selector: #selector(timerCallback),userInfo: nil,repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        theBool = true
    }
}
