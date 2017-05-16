//
//  LeaderboardController.swift
//  Budget_app
//
//  Created by app on 1/26/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit

class UserDataCell: UITableViewCell {
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelFrame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }

}

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableviewUser: UITableView!
    
    var userName = ["User"]
    var userCount = [1]
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewUser.backgroundColor = UIColor(red: 120, green: 68, blue: 33, alpha: 1)
        tableviewUser.backgroundView?.backgroundColor = UIColor(red: 120, green: 68, blue: 33, alpha: 1)
        
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "UserName") as? String {
            navigationItem.title = value
        }
        
        var count = 0
        for var i in 0...2 {
            if let value = defaults.value(forKey: navigationItem.title! + "awards" + String(i)) as? NSNumber {
                count += value.intValue
            }
        }
        
        userName[0] = navigationItem.title!
        userCount[0] = count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as! UserDataCell
        cell.labelUser?.text = userName[indexPath.row]
        cell.labelCount?.text = String(userCount[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(red: 120, green: 68, blue: 33, alpha: 1)
    }
}
