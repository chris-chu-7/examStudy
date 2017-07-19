//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    //prompts the user to Log In
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() //sets up activity indicator
    
    @IBOutlet weak var usernameTextField: UITextField! //sets up a username Text Field
    @IBOutlet weak var passwordTextField: UITextField!//sets up a password Text Field
    
    
    
    @IBAction func Login(_ sender: Any) {
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
                                                              //while the connection is loading up
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
            if error != nil{
                self.activityIndicator.stopAnimating() //if there is an error, allow the user to try again
                self.createAlert(title: "Error", message: "Cannot Log In.")
                UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
            }
            
            else {
                print("Logged In :)") //debugger
                self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
                                                        //and move on to the next window.
                UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
                self.performSegue(withIdentifier: "logInSuccessful", sender: self) //go to the user homepage if login in successful
                
            }
                
            })
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
        //while the connection is loading up
        performSegue(withIdentifier: "loginToSignup", sender: self) //transfers user to the sign up window
        activityIndicator.stopAnimating() //stop animating the activity indicator once the screen changes
        UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the text fields to modify to belong to this particular view controller
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     This create alert method presents an alert with a title presented on the top and message on the bottom,
     usually for errors.
     */
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil) //bottom button of the alert for the user to dismiss
        }))
        
        self.present(alert, animated: true, completion: nil) //actually present (pop out) the notification when needed
        
    }
    
    /*
     The next two functions simply dismiss the username and password keyboard when return is hit.
     */
    
    func dismissKeyboard(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
