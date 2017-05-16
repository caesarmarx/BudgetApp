//
//  MenuView.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

protocol MenuProtocol {
    func doTapReservation()
    func doTapChat()
    func doTapLeaderboard()
    func doTapSugesstion()
    func doTapAbout()
}

class MenuViewController: UIViewController {
    var task: MenuProtocol?
    
    @IBAction func onTapReservation(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        task?.doTapReservation()        
    }
    
    @IBAction func onTapChat(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        task?.doTapChat()
    }
    
    @IBAction func onTapLeaderboard(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        task?.doTapLeaderboard()
    }
    
    @IBAction func onTapSuggestion(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        task?.doTapSugesstion()
    }
    
    @IBAction func onTapAbout(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        task?.doTapAbout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
