//
//  updateProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class updateProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var profilePicture: UIImageView! //change the profile picture
    @IBOutlet weak var maleOrFemale: UISwitch! //decide if the user is male or female
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() //sets up activity indicator
    @IBOutlet weak var phoneNumber: UITextField!  //change phone number
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.text = (PFUser.current()?["phoneNumber"] as! String) //set the phone number
        let isFemale = PFUser.current()?["isFemale"] as! Bool //set isfemale boolean
        maleOrFemale.isOn = isFemale //set the switch
        let userProfilePhoto = PFUser.current()?["profilePicture"] as! PFFile
        userProfilePhoto.getDataInBackground { (imageData, error) in
            if error != nil{
                print("cannot get profile photo")
            } else {
                let image = UIImage(data: imageData!)
                self.profilePicture.image = image //sets the default user profile picture
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        
        let imagePicker = UIImagePickerController() //sets up in image picker so the user picks profile picture from his/her photo
        //library
        imagePicker.delegate = self
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil) //present the image controller
        self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
        //and move on to the next window.
        UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profilePicture.image = image //set the camera roll image to the profile image
        }
        
        self.dismiss(animated: true, completion: nil) //get rid of the image picker controller
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents() //prevents the user from interacting with the screen
        PFUser.current()?["isFemale"] = maleOrFemale.isOn //save the gender
        let imageData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5) //set the image
        
        if let picture = PFFile(name: "PhotoBooth.png", data: imageData!){ //saves the profile picture of the user in the parse server
            PFUser.current()?["profilePicture"] = picture
        } else {
            self.createAlert(title: "Error", message: "Picture is too large")
        }
        
        
          PFUser.current()?["phoneNumber"] = phoneNumber.text! //save the phonenumber if there is text entered
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil{
                self.createAlert(title: "Error", message: "Cannot save data")
            } else {
                self.createAlert(title: "Success", message: "Data Saved")
                self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
                //and move on to the next window.
                UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
            }
        })
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "updateToSettings", sender: self)
    }
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        activityIndicator.center = self.view.center //center of view controller
        activityIndicator.hidesWhenStopped = true //gets rid of indicator when page is ready
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white //sets the color of the activity indicator to gray
        view.addSubview(activityIndicator) //adds the activity indicator to the view
        activityIndicator.startAnimating()
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete your account", preferredStyle: UIAlertControllerStyle.alert) //create an alert
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            PFUser.current()?.deleteInBackground(block: { (success, error) in //delete the account
                if error != nil {
                    alert.dismiss(animated: true, completion: nil)
                    self.createAlert(title: "Error", message: "Cannot delete account")
                    self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
                    //and move on to the next window.
                    UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
                } else {
                    alert.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "deleteAccount", sender: self) //go back to the login page
                    self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
                    //and move on to the next window.
                    UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.activityIndicator.stopAnimating()// if there is no error, stop animating the wait button
            //and move on to the next window.
            UIApplication.shared.endIgnoringInteractionEvents() //allow the user to interact with the screen again

        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder() //release the keyboard when the user touches to a random loaction
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
