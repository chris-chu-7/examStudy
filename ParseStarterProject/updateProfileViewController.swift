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
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var maleOrFemale: UISwitch!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView() //sets up activity indicator
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: PFUser.current()?["username"])
        query?.findObjectsInBackground(block: { (object, error) in
            if error != nil {
                print("error: cannot find picture")
            } else {
                print("found picture")
                
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        let imagePicker = UIImagePickerController() //sets up in image picker so the user picks profile picture from his/her photo
        //library
        imagePicker.delegate = self 
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil) //present the image controller
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
        PFUser.current()?["isFemale"] = maleOrFemale.isOn
        let imageData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
        
        if let picture = PFFile(name: "PhotoBooth.png", data: imageData!){ //saves the profile picture of the user in the parse server
            PFUser.current()?["profilePicture"] = picture
        } else {
            self.createAlert(title: "Error", message: "Picture is too large")
        }
        
        if phoneNumber.text != ""{
          PFUser.current()?["phoneNumber"] = phoneNumber.text!
        }
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder()
    }
    
    
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
