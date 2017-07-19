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
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mileRange: UITextField!
    @IBOutlet weak var classCode: UITextField!
    
    var userLatitude:Double = 0
    var userLongitude:Double = 0
     let manager = CLLocationManager()
    var location: CLLocation!
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "mapToSettings", sender: self)
    }
    
    
    @IBAction func classmateSearch(_ sender: Any) {
        if let miles = Double(mileRange.text!){
            let span = Double(miles * 0.02)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
            self.map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
        
        //This is a query to attempt to find Geopoints
        if let locations = manager.location?.coordinate{
            let studentsNearMeQuery = PFUser.query()
            studentsNearMeQuery?.whereKey("Location", nearGeoPoint: PFGeoPoint(latitude: locations.latitude, longitude: locations.longitude))
            
            studentsNearMeQuery?.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    self.createAlert(title: "Error", message: "Cannot find students")
                } else {
                    if let object = objects{
                        for one in object{
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: (one["Location"] as AnyObject).latitude, longitude: (one["Location"] as AnyObject).longitude)
                            annotation.title = (one["username"] as! String)
                            
                            
                            annotation.subtitle = ("No number")
                            
                            if (one["phoneNumber"] as? String != nil){
                                if one["phoneNumber"] as! String != ""{
                                    annotation.subtitle = (one["phoneNumber"] as! String)
                                }
                            }
                            self.map.addAnnotation(annotation)
                        }
                    }
                }
            })
        }
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as! CLLocation
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareLocation(_ sender: Any) {
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        let point = PFGeoPoint(latitude: userLatitude, longitude: userLongitude)
        PFUser.current()?["Location"] = point
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                self.createAlert(title: "Error", message: "Failed to save location.")
            } else {
                self.createAlert(title: "Success", message: "Location updated.")
            }
        })
        print("Location shared")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mileRange.resignFirstResponder() //when the screen is touched, get rid of the keyboard
        classCode.resignFirstResponder()
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
