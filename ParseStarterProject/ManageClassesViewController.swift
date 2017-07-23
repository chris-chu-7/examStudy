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
        classes = PFUser.current()?["Courses"] as! [String]
        classList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToSettings(_ sender: Any) {
        performSegue(withIdentifier: "doneManagingClasses", sender: self)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return classes.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        
        cell.textLabel?.text = classes[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.classes.remove(at: indexPath.row)
            PFUser.current()?["Courses"] = classes
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil{
                    self.createAlert(title: "Error", message: "Class not updated")
                } else {
                    print("success:)")
                }
            })
            self.classList.reloadData()
        }
    }
    
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
