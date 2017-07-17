//
//  SettingsTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    
    var pets = ["Log Out", "cat", "rabbit"]
    var petDesc = ["bones", "fish", "carrots"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = pets[indexPath.row]

        // Configure the cell...

        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0{
        PFUser.logOut()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

}
