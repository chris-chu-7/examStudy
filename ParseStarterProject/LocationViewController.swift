//
//  LocationViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

class LocationViewController: UIViewController , CLLocationManagerDelegate {
    
    //map imported
    @IBOutlet weak var map: MKMapView! //map
    @IBOutlet weak var mileRange: UITextField! //a tool for users to specify the distance to search for study partners
    @IBOutlet weak var classCode: UITextField! //a query tool to limit the study partners by class code
    
    var userLatitude:Double = 0 //changable latitude
    var userLongitude:Double = 0 //changable longitude
     let manager = CLLocationManager() //manages the user location
    var location: CLLocation! //sets up the user location latitude and longitude
    var southwest: PFGeoPoint!
    var northeast: PFGeoPoint!
    var mileLimit:Double = 0
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "mapToSettings", sender: self) //go to the settings
    }
    
    
    @IBAction func classmateSearch(_ sender: Any) {
        
        southwest = PFGeoPoint(latitude: location.coordinate.latitude - 0.001, longitude: location.coordinate.longitude - 0.001)
        northeast = PFGeoPoint(latitude: location.coordinate.latitude + 0.001, longitude: location.coordinate.longitude + 0.001)
        
        if mileRange.text == nil {
            self.createAlert(title: "Error", message: "Enter a numerical value.")
        }
        
        
        if let miles = Double(mileRange.text!) { //check to see if the user entered a number in the miles range
            mileLimit = miles
            if miles <= 30{
            
            let span = Double(miles * 0.02) //conversion of latitude to span (FIXME)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) //sets the center of the map to user location
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)) //sets the region
            self.map.setRegion(region, animated: true) //adds the region
            self.map.showsUserLocation = true //adds the current user location circle
            southwest = PFGeoPoint(latitude: (manager.location?.coordinate.latitude)! - span * 2, longitude: (manager.location?.coordinate.longitude)! - span * 2)
            northeast = PFGeoPoint(latitude: (manager.location?.coordinate.latitude)! + span * 2, longitude: (manager.location?.coordinate.longitude)! + span * 2)
            }
            else {
                self.createAlert(title: "Error", message: "Number must be less than 30 miles")
            }
        } else {
            self.createAlert(title: "Error", message: "Please enter a number.")
        }
            
        
        //This is a query to attempt to find Geopoints
        
        if mileLimit <= 2500{
        if (manager.location?.coordinate) != nil{
            
            
            let studentsNearMeQuery = PFUser.query() //look for close students
            studentsNearMeQuery?.whereKey("Location", withinGeoBoxFromSouthwest: southwest, toNortheast: northeast) //look for students near the particular GeoPoint(FIXME)
            
            studentsNearMeQuery?.findObjectsInBackground(block: { (objecto, error) in
                if error != nil {
                    self.createAlert(title: "Error", message: "Cannot find students") //display an error message in the case of an error
                } else {
                    
                    let classQuery = PFUser.query()
                    classQuery?.whereKey("Courses", contains: self.classCode.text)
                    
                    classQuery?.findObjectsInBackground(block: { (objects, error) in
                        if error != nil{
                            let allAnnotations = self.map.annotations
                            self.map.removeAnnotations(allAnnotations)
                            self.createAlert(title: "Error", message: "Cannot find any Students")
                        } else {
                            let allAnnotations = self.map.annotations
                            self.map.removeAnnotations(allAnnotations)
                            if let object = objects{
                                
                                if let objecta = objecto{
                                
                                if objecta.count > 0{
                                for one in objecta{ //for every student in the query
                                    
                                    let annotation = MKPointAnnotation() //initialize an annotation
                                    annotation.coordinate = CLLocationCoordinate2D(latitude: (one["Location"] as AnyObject).latitude, longitude: (one["Location"] as AnyObject).longitude) //put the annotation in the location of the other users
                                    annotation.title = (one["username"] as! String) //display the user name
                                    
                                    
                                    annotation.subtitle = ("No number") //the other annotation displays the user phone number,
                                    //if there is no phone number, then display this default message (error prevention)
                                    
                                    if (one["phoneNumber"] as? String != nil){
                                        if one["phoneNumber"] as! String != ""{
                                            annotation.subtitle = (one["phoneNumber"] as! String) //if the phonenumber is entered successfully, display the phone # in the annotation subtitle
                                        }
                                    }
                                    self.map.addAnnotation(annotation) //add the annotation
                                }
                            }
                                    
                                }
                                
                                
                            } //DO
                        }
                    })
                    
                    
                    
                }
                
                
            })
        }
        } else {
            self.createAlert(title: "Error", message: "30 miles is the maximum")
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as! CLLocation //update the location every time the user clicks "update"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()     //sets up the map for the locations to update successfully
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareLocation(_ sender: Any) {
        userLatitude = location.coordinate.latitude //points to share the location
        userLongitude = location.coordinate.longitude
        
        let point = PFGeoPoint(latitude: userLatitude, longitude: userLongitude) //make a geopoint with the coordinate points
        PFUser.current()?["Location"] = point
        
        
        /*
         *The next method attempts to save the user location.
         */
        
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                self.createAlert(title: "Error", message: "Failed to save location.")
            } else {
                self.createAlert(title: "Success", message: "Location updated.")
            }
        })
        print("Location shared")
        
    }
    
    @IBAction func cancelLocation(_ sender: Any) {
        PFUser.current()?["Location"] = PFGeoPoint(latitude: 0, longitude: 0)
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                self.createAlert(title: "Error", message: "Cannot set point")
            } else {
                self.createAlert(title: "You are hidden", message: "mwaHAHAHA>:)")
            }
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mileRange.resignFirstResponder() //when the screen is touched, get rid of the keyboards of both text fields.
        classCode.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mileRange.resignFirstResponder() //when the screen is returned, get rid of the keyboards of both text fields.
        classCode.resignFirstResponder()
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
