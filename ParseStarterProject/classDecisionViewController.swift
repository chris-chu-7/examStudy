//
//  classDecisionViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class classDecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var classQuery: UIView! //Window 1 to search for classes
    @IBOutlet var classRate: UIView! //Window 2 with the tableView of student Rankings
    @IBOutlet weak var className: UITextField! //bar for the user to search for a particular class
    
    @IBOutlet weak var flipCardButton: UIButton! //button to flip fron classQuery to classRate
    @IBOutlet weak var tableView: UITableView!
    
    
   // var classSuccess = false //placeholder to see if the class is found and to check if to move UIViews
    var classType = "" //placeholder variable for className
    var classes = [String]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var classExists = true
    var userClasses = ["eS"]
    var link = " "
    
    
    
    /*func refreshData(){
        classes.append(" ")
        refreshControl.endRefreshing()
    }*/
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "firstWindowToSettings", sender: self) //moves the user to the Settings Panel
    }
    
    @IBAction func review(_ sender: Any) {
        performSegue(withIdentifier: "reviewClass", sender: self) //allows the user to review a particular URL (move windows to powerScore rater)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //efreshControl.addTarget(self, action: #selector(ViewController.refreshData), for: UIControlEvents.valueChanged)
        //tableView.addSubview(refreshControl)
        
        PFUser.current()?["Courses"] = userClasses
        userClasses = PFUser.current()?["Courses"] as! [String]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flipCard(_ sender: Any) {
       /*
        if classSuccess == true{
            
        flipCardButton.alpha = 0
        UIView.transition(from: classQuery, to: classRate, duration: 0.5, options: .transitionFlipFromRight)
        goBackButton.alpha = 1
            
        }
 */
    }
    
    
    

    
    
    /*
     method creates a class in the parseServer
 */
    
    /*
     needs fixing
     */
    
    @IBAction func createClass(_ sender: Any) {
        
        let query = PFQuery(className: "Classes") //search in classes
        query.whereKey("name", equalTo: className.text!) //see if there are any existing classes with the same class name
        query.getFirstObjectInBackground { (object, error) in
            if error != nil{
                if self.className.text != ""{ //if the class is not found, then it can be created
                    let newClass = PFObject(className: "Classes") //create a new object
                    newClass["name"] = self.className.text //initialize the object's class name
                    newClass.saveInBackground { (success, error) in //save the object
                        if error != nil{
                            self.createAlert(title: "Error", message: "Class Creation Failed") //print an error message if the class cannot be created
                        } else {
                            self.createAlert(title: "Success", message: ":)") //else, if success, send the user a notification
                            //self.classSuccess = true
                            //self.flipCardButton.alpha = 0
                            self.classQuery.alpha = 0
                            
                            /*
                             the next three lines perform a transition between windows
                             */
                            self.classRate.alpha = 1
                            self.classExists = true
                            UIView.transition(from: self.classQuery, to: self.classRate, duration: 0.5, options: .transitionFlipFromRight)
                            // self.goBackButton.alpha = 1
                        }
                    }
                    
                } else {
                    self.createAlert(title: "Error", message: "Class Creation Failed") //print an error if the text field is left blank
                }
            } else {
                self.createAlert(title: "Error", message: "Class Creation Failed") //print an error if parseServer cannot be accessed
            }
        }
        
    }
    
    
    /*
     needs fixing
 */
    @IBAction func searchClass(_ sender: Any) {
        
        let query = PFQuery(className: "Classes") //search in classes
        query.whereKey("name", equalTo: className.text!) //see if there are any classes corresponding to what was put in the text field
        query.getFirstObjectInBackground { (object, error) in
            if error == nil{
                self.createAlert(title: "Success", message: "Found query") //indicate success
               let query = PFQuery(className: "URLs") //now search the particular class name in the URLs
               query.whereKey("Classes", contains: self.className.text!) //see if there are any URLs corresponding to the class arrays containing the URLs
                query.order(byDescending: "powerScore") //now arrange these urls containing the class into a corresponding powerScore
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        self.createAlert(title: "Error", message: "Failed to load list") //if the objects can't be fetched,
                                                                                        // print an error message
                    } else {
                        print("Objects should be retrieved") //debugger
                        self.tableView.alpha = 1
                        if let objects = objects{
                            for object in objects{
                                self.classes.append(object["URL"] as! String) //get all the objects arranged in order in an array to code to the table
                            }
                        }
                        print(self.classes) //debugger
                        self.tableView.reloadData() //reload the table dagta
                        UIView.transition(from: self.classQuery, to: self.classRate, duration: 0.5, options: .transitionFlipFromRight) //if there is a success, change views
                    }
                })
            }
            else {
                self.createAlert(title: "Error", message: "Cannot Find query") //else, if no class of type exists, print an error message
            }
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
    
    @IBAction func addClass(_ sender: Any) {
        
        
        let query = PFQuery(className: "Classes") //query to search the classes
        query.whereKey("name", equalTo: className.text!) //query to search anything equal to the class's name
        query.getFirstObjectInBackground { (object, error) in
            if error != nil {
                self.createAlert(title: "Error", message: "Cannot add class to Student") //if class name is not found, the student cannot be add the class
                
            } else {
                self.userClasses.append(self.className.text!) //otherwise, add all the user classes to the array
                PFUser.current()?["Courses"] =  self.userClasses //put the classes array back with the user
                PFUser.current()?.saveInBackground(block: { (success, error) in //try to save the parse
                    if error != nil {
                        self.createAlert(title: "Error", message: "Cannot add class to Student")
                    }
                        
                    else{
                        self.createAlert(title: "Success", message: "Class added")
                    }
                })
                
            }
        }
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        className.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        className.resignFirstResponder()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView"{
            
           let webController = segue.destination as! WebViewController
            webController.myString = link
            
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return classes.count //displays all the sources that are corresponding to a class
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell") //initialize a cell
        cell.textLabel?.text = String(indexPath.row + 1) + ". " + classes[indexPath.row] //the table cell contents are the courses for the URL sorted by powerScore
        return cell //return the text content
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selects a row
        link = classes[indexPath.row]
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    

}
