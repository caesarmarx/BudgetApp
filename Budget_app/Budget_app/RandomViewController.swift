//
//  RandomViewController.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

class RandomViewController: UIViewController{
    
    @IBOutlet weak var viewMask: UIView!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var textfieldFood: UITextField!
    @IBOutlet weak var textfieldDrink: UITextField!
    @IBOutlet weak var textfieldFoodamount: UITextField!
    @IBOutlet weak var textfieldAmount: UITextField!
    @IBOutlet weak var textfieldLocation: UITextField!
    
    var isSubmit: Bool = false
    var INFOSERVICE_URL = "http://www.budgeat.co/api/products/"

    // Actions

    @IBAction func onTapAdd(_ sender: Any) {
        isSubmit = true
        updateUI()
    }
    
    @IBAction func onTapRefresh(_ sender: Any) {
        self.view.makeToast(message: "fetching...", duration: 3.0, position: "bottom" as AnyObject)
        LoadInfo(fromURL: INFOSERVICE_URL, downloadInfo: downloadInfo)
    }
    
    @IBAction func onTapBackground(_ sender: Any) {
        isSubmit = false
        updateUI()
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapShare(_ sender: Any) {
        guard let url = takeScreenshot(view: view) else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: ["WOW! I've just discovered this 'MEAL' for this 'PRICE' at this 'PLACE', get yours via || #Budgeat_app || www.budgeat.co", url],
            applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onTapSubmit(_ sender: Any) {
        if textfieldFood.text == "" || textfieldDrink.text == "" || textfieldFoodamount.text == "" || textfieldAmount.text == "" || textfieldLocation.text == "" {
            view.makeToast(message: "All parameters are needed")
        } else {
            postURL(params: ["actual_food_amount": textfieldFoodamount.text!, "amount": textfieldAmount.text!, "drink": textfieldDrink.text!, "food": textfieldFood.text!, "location": textfieldLocation.text!], url: "www.budgeat.co/post_mobile", view: view)
            //view.makeToast(message: "Successfully added")
            isSubmit = false
            updateUI()
        }
    }
    //override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        onTapRefresh(self)
    }
    
    func updateUI() {
        viewMask.isHidden = !isSubmit
        viewSubmit.isHidden = !isSubmit
    }
    
    func downloadInfo(info: NSDictionary) {
        let amount = info["amount"] as! String, food = info["food"] as! String, drink = info["drink"] as! String, location = info["location"] as! String
        DispatchQueue.main.async {
            self.labelInfo.text = "$" + amount + " gets you a " + food + " and a " + drink + " @ " + location
            self.view.makeToast(message: "fetched")
        }
    }
}
