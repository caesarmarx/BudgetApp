//
//  SuggestionViewController.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit
import MessageUI

class SuggestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var textviewMessage: UITextView!
    
    var fromData = ["from ... ", "Pop's Rotisorie", "Old Stone Grill & Bar"]
    var indexRow = 0
    
    // Actions
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapSubmit(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            view.makeToast(message: "Mail was sent successfully")
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    // override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "UserName") as? String {
            navigationItem.title = value
        }
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fromData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fromData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        indexRow = row
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)        
    }
    
    // Functions
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let to:String = "info@budgeat.co"
        let subject:String = "new Reservation from BudgEat App"
        let email_message:String = textviewMessage.text
            
        mailComposerVC.setToRecipients([to])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(email_message, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        view.makeToast(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
}
