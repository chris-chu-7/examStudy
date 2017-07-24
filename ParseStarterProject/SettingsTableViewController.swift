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
    
    var settings = ["Help","Edit Profile", "Home Page", "Manage Classes", "Log Out"] //array that has every aspect of the tableView

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
        return settings.count //display all of the settings aspects in the array
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = settings[indexPath.row] //put the array text in the table view controller

        // Configure the cell...

        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == settings.count - 1{
            PFUser.logOut()
            performSegue(withIdentifier: "logout", sender: self) //if the last button is clicked, logout and move to the start screen.
        }
    
        if indexPath.row == settings.count - 3{
            performSegue(withIdentifier: "settingsToHome", sender: self) //go back to the home page
        }
    
        if indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToHelp", sender: self) //go to help page
        }
    
    if indexPath.row == 1{
            performSegue(withIdentifier: "settingsToEdit", sender: self) //edit profile
    
        }
    
    if indexPath.row == 3{
        performSegue(withIdentifier: "manageClasses", sender: self) //help the user manage his/her classes
    }
    
    }
    

    

}
