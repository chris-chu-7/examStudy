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
    var userLatitude:Double = 0
    var userLongitude:Double = 0
     let manager = CLLocationManager()
    var location: CLLocation!
    
    @IBAction func classmateSearch(_ sender: Any) {
        if let miles = Double(mileRange.text!){
            let span = Double(miles * 0.02)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
            self.map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
        
        
        
        //create a query
        let userGeoPoint = PFUser.current()?["Location"] as! PFGeoPoint
        
        if let miles = Double(mileRange.text!){
            let span = Double(miles * 0.01)
        let northEastPoint = PFGeoPoint(latitude: location.coordinate.latitude + span, longitude: location.coordinate.longitude + span)
        let southWestPoint = PFGeoPoint(latitude: location.coordinate.latitude - span, longitude: location.coordinate.longitude - span)
        
        let query = PFQuery(className: "User")
        query.whereKey("Location", withinGeoBoxFromSouthwest: southWestPoint, toNortheast: northEastPoint)
            query.findObjectsInBackground(block: { (objects, error) in
                if error != nil {
                    self.createAlert(title: "Error", message: "Cannot find People at this time")
                } else {
                    self.createAlert(title: "Success", message: "This people thing works!")
                    
                    
                    if let object = objects{
                        for object in objects!{
                            print(object.objectId)
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
