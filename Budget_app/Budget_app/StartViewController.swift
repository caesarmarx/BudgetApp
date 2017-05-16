//
//  StartViewController.swift
//  Budget_app
//
//  Created by app on 1/25/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var textfieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelDescription.textAlignment = .center
        labelDescription.text = "enter your name below to start \n enjoying the full suite of \n BudgEat's Services";
        labelDescription.lineBreakMode = .byWordWrapping
        labelDescription.numberOfLines = 0;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if (defaults.value(forKey: "UserName") as? String) != nil {
            performSegue(withIdentifier: "StartToPunchcard", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldName.resignFirstResponder()
        
        let defaults = UserDefaults.standard
        defaults.setValue(textfieldName.text, forKey: "UserName")
        defaults.synchronize()
        
        performSegue(withIdentifier: "StartToPunchcard", sender: self)
        return true
    }
}
