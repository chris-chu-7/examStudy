//
//  ClassReviewViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ClassReviewViewController: UIViewController {
    
    @IBOutlet weak var url: UITextField! //url of main source that the student went to study
    @IBOutlet weak var hourStudy: UITextField! //number of hours in which the student studied
    @IBOutlet weak var testScore: UISlider! //The student's final score on his/her exam
    @IBOutlet weak var testDifficulty: UISlider! //(subjectively) how hard the student felt his/her test was
    @IBOutlet weak var powerScore: UILabel! //the final effectiveness score that the study source gets
    @IBOutlet weak var scoreLabel: UILabel! //assists the user in selecting a test score
    @IBOutlet weak var classCode: UITextField! //class the student participated in
    
    var numHours = 10 //number of hours spent studying placeholder
    var score = 0 //placeholder value for powerScore to be sent to ParseServer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scoreValue(_ sender: Any) {
        let currentValue = Int(testScore.value) //store the score of the testScore slider into a temporary parameter
        
        /*
         This method changes the color of the test score based on how good the user performed on his/her exam
         */
        
        if currentValue > 85{
            if #available(iOS 10.0, *) {
                scoreLabel.textColor = UIColor(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1)
            } else {
                print("Color error")
            }
        }
        
        
        if currentValue <= 85 && currentValue >= 75{
           scoreLabel.textColor = UIColor.green
        }
        
        if currentValue > 50 && currentValue < 65 {
            scoreLabel.textColor = UIColor.orange
        }
        
        if currentValue > 65 && currentValue < 75{
            scoreLabel.textColor = UIColor.yellow
        }
        
        if currentValue <= 50 {
            scoreLabel.textColor = UIColor.red
        }
        
        
        scoreLabel.text = String(currentValue) //display the reader on the slider
    }
    
    /*
     this algorithm sets the power score, a value that determines the effectiveness of a URL
     */
    @IBAction func seePowerScore(_ sender: Any) {
        let hardness = Int(testDifficulty.value) //value for how difficult the course/exam was
        let currentValue = Int(testScore.value) //value for the score recieved on the exam
        
        if let hours = Int(hourStudy.text!){ //check to see if the user inputted an integer. avoid errors
            if hourStudy.text != "0"{
                numHours = hours
            }
        }
        
        let amountPower = currentValue * hardness / numHours //specific equation to determine the effectiveness of a website
        powerScore.text = String(amountPower)
        score = amountPower //this is a placeholder for the powerScore to put in the parseServer and eventually, the table
    }
    
    
    /*
     Submits the rating to the parseServer to be stored and eventually saved in the table
    */
    
    
    @IBAction func submitReview(_ sender: Any) {
        let query = PFQuery(className: "URLs") //look in the URL class
        query.whereKey("URL", equalTo: url.text!) //make a query to see if the URL already exists
        query.getFirstObjectInBackground { (objects, error) in
            if error != nil{
                //say the first object does not exist, then
                let newURL = PFObject(className: "URLs")
                newURL["URL"] = self.url.text //make a new URL
                newURL["Course"] = self.classCode.text
                newURL["ReviewNum"] = 1
                newURL["powerScore"] = self.score //set the number of reviews of the new URL to 1 and the power score
                                                    //to the initial powerScore
                newURL.saveInBackground(block: { (success, error) in //save the new url
                    if error != nil{
                        print("did not save")
                    } else {
                        print("URL saved")
                    }
                })
            } else { //if the url already exists
                let object = objects?.objectId //retrieve the object id from the initial query
                print(object!)
                let query = PFQuery(className: "URLs")
                query.getObjectInBackground(withId: object!, block: { (anobject, error) in //set the object as avalable to mutate
                    if error != nil{
                        //print(error)
                    } else {
                        var count = anobject!["ReviewNum"] as! Int
                        count = count + 1
                        anobject!["ReviewNum"] = count //temporary variable to increment the number of responses
                        let newPowerScore = (anobject!["powerScore"] as! Int  * (count - 1) + self.score) / (count) //average out the powerScores
                        anobject!["powerScore"] = newPowerScore //update the powerScore
                        anobject?.addObjects(from: [self.classCode.text!], forKey: "Classes")
                        
                        anobject?.saveInBackground(block: { (success, error) in //save all changes
                            if error != nil{
                                print("Object is not saved.")
                            } else {
                                print("Object saved")
                            }
                        })
                    }
                })
                
            }
        
        
        }
        
    }
    
    
    
    @IBAction func gotoSettings(_ sender: Any) {
        performSegue(withIdentifier: "rateToSettings", sender: self) //go to the settings when the settings button is hit
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hourStudy.resignFirstResponder() //when the screen is touched, get rid of the keyboard
        classCode.resignFirstResponder()
        url.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hourStudy.resignFirstResponder() //when the screen is touched, get rid of the keyboard
        classCode.resignFirstResponder()
        url.resignFirstResponder()
        return true
    }
    
    
}
