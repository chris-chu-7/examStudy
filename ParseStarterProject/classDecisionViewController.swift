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
    @IBOutlet weak var goBackButton: UIButton! //button to flip fron classRate to classQuery
    
    var classSuccess = false //placeholder to see if the class is found and to check if to move UIViews
    var classType = "" //placeholder variable for className
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "firstWindowToSettings", sender: self) //moves the user to the Settings Panel
    }
    
    @IBAction func review(_ sender: Any) {
        performSegue(withIdentifier: "reviewClass", sender: self) //allows the user to review a particular URL (move windows to powerScore rater)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
    @IBAction func goBack(_ sender: Any) {
        //goBackButton.alpha = 0
        UIView.transition(from: classRate, to: classQuery, duration: 0.5, options: .transitionFlipFromLeft) //flip card again if user is in the table and wants to search for alternative classes
        //flipCardButton.alpha = 1
    }
    
    
    /*
     method creates a class in the parseServer
 */
    
    /*
     needs fixing
     */
    
    @IBAction func createClass(_ sender: Any) {
        
        let query = PFQuery(className: "Classes")
        query.whereKey("name", equalTo: className.text!)
        query.getFirstObjectInBackground { (object, error) in
            if error != nil{
                if self.className.text != ""{
                    let newClass = PFObject(className: "Classes")
                    newClass["name"] = self.className.text
                    newClass.saveInBackground { (success, error) in
                        if error != nil{
                            self.createAlert(title: "Error", message: "Class Creation Failed")
                        } else {
                            self.createAlert(title: "Success", message: ":)")
                            self.classSuccess = true
                            //self.flipCardButton.alpha = 0
                            self.classQuery.alpha = 0
                            self.classRate.alpha = 1
                            UIView.transition(from: self.classQuery, to: self.classRate, duration: 0.5, options: .transitionFlipFromRight)
                            // self.goBackButton.alpha = 1
                        }
                    }
                    
                } else {
                    self.createAlert(title: "Error", message: "Class Creation Failed")
                }
            } else {
                self.createAlert(title: "Error", message: "Class Creation Failed")
            }
        }
        
    }
    
    
    /*
     needs fixing
 */
    @IBAction func searchClass(_ sender: Any) {
        
        let query = PFQuery(className: "Classes")
        query.whereKey("name", equalTo: className.text!)
        query.getFirstObjectInBackground { (object, error) in
            if error == nil{
                self.createAlert(title: "Success", message: "Found query")
            }
            else {
                self.createAlert(title: "Error", message: "Cannot Find query")
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tableCell")
        cell.textLabel?.text = "It works!"
        return cell
    }
    

}
