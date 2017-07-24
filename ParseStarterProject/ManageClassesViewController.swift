//
//  ManageClassesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ManageClassesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var classList: UITableView!
    var classes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classes = PFUser.current()?["Courses"] as! [String] //load all the classes from parse to an array
        classList.reloadData() //reload the table so that it displays something
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToSettings(_ sender: Any) {
        performSegue(withIdentifier: "doneManagingClasses", sender: self) //go back to the settings
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return classes.count //Parse class count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        
        cell.textLabel?.text = classes[indexPath.row]
        
        return cell //take the array of the classes the user is enrolled into and return it into a cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{ //have a delete option
            self.classes.remove(at: indexPath.row)
            PFUser.current()?["Courses"] = classes //update the parse data
            PFUser.current()?.saveInBackground(block: { (success, error) in //save
                if error != nil{
                    self.createAlert(title: "Error", message: "Class not updated")
                } else {
                    print("success:)")
                }
            })
            self.classList.reloadData() //reload the table once deleted, also an error prevention key
        }
    }
    
    
    /*
     This create alert method presents an alert with a title presented on the top and message on the bottom,
     usually for errors.
     */
    
    
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
