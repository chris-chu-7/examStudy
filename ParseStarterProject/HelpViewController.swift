//
//  HelpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class HelpViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var request: UITextView!
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "helpToSettings", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // request.delegate = self as! UITextViewDelegate //delegates self
        request.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        if request.text != ""{ //checks to make sure the text is not empty
            let userRequest = PFObject(className: "Request") //initializes a new request object
            userRequest["Request"] = request.text //updates the request text
            userRequest["User"] = PFUser.current()?["username"] //shows who sent the text
            userRequest.saveInBackground(block: { (success, error) in
                if error != nil{
                    self.createAlert(title: "Error", message: "Cannot send request.") //if the request cannot be sent, display an error message
                } else {
                    self.createAlert(title: "Success", message: "Request Sent") //if the request is sent, display a success message
                }
            })
            
        } else {
            self.createAlert(title: "Error", message: "Must enter some text :O") //if there is not text, display an error message
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        request.resignFirstResponder() //resigns the request text field when "return" is pressed
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       request.resignFirstResponder() //resigns the request text field when the screen is touched
    }
    
    
    @nonobjc func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            request.resignFirstResponder()
            return false
        }
        return true
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
