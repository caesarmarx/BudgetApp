//
//  AboutViewController.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    //Actions
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapTwitter(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("http://www.twitter.com/budgeat_app", forKey: "WebViewURL")
        defaults.synchronize()
        performSegue(withIdentifier: "AboutToWeb", sender: self)
    }
    
    @IBAction func onTapFacebook(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("http://www.facebook.com/BudgEat", forKey: "WebViewURL")
        defaults.synchronize()
        performSegue(withIdentifier: "AboutToWeb", sender: self)
    }
    
    @IBAction func onTapRss(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("http://www.budgeat.co", forKey: "WebViewURL")
        defaults.synchronize()
        performSegue(withIdentifier: "AboutToWeb", sender: self)
    }
    
    //override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
