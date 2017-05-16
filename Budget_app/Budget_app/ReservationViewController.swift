//
//  ReservationController.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit
import MessageUI

class ReservationViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIPickerViewDataSource,UIPickerViewDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var pickerFrom: UIPickerView!
    @IBOutlet weak var pickerPerson: UIPickerView!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var textfieldPhone: UITextField!
    
    var fromData = ["from ... ", "Pop's Rotisorie", "Old Stone Grill & Bar"]
    var personData = ["# of Person/s", "1", "2", "3", "4"]
    var indexFrom = 0
    var indexPerson = 0
    
    //Actions
    
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
    
    //override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "UserName") as? String {
            navigationItem.title = value
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM - yyyy"
        labelMonth.text = dateFormatter.string(from: (viewCalendar as! FSCalendar).currentPage)
        
        textfieldPhone.backgroundColor = UIColor.clear
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return fromData.count
        }
        else {
            return personData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return fromData[row]
        }
        else {
            return personData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            indexFrom = row
        }
        else {
            indexPerson = row
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {

    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM DD YYYY"
        
        labelDate.text = dateFormatter.string(from: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM - yyyy"
        labelMonth.text = dateFormatter.string(from: calendar.currentPage)
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    // Functions
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let rr = fromData[indexFrom]
        let rp = personData[indexPerson]
        let rd = labelDate.text
        let rn = textfieldPhone.text
        var email_message:String = rr + ", you have a new reservation :\n Customer: " + rn!
        email_message = email_message + "\nTime: " + rd! + "\nFor "
        email_message = email_message + rp + "\n\n\ncoming to you from the lovely team @ www.budgeat.co"
        
        let to:String = "info@budgeat.co"
        let subject:String = "new Reservation from BudgEat App"
        
        mailComposerVC.setToRecipients([to])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(email_message, isHTML: false)
        //mailComposerVC.setType("message/rfc822")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        view.makeToast(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
}
