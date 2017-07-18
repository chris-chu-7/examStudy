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
    var userLatitude:Double = 0
    var userLongitude:Double = 0
    
     let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] //update user's most recent position
        userLatitude = Double(location.coordinate.latitude)
        userLongitude = Double(location.coordinate.longitude)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
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
        let point = PFGeoPoint(latitude: userLatitude, longitude: userLongitude)
        PFUser.current()?["Location"] = point
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                self.createAlert(title: "Error", message: "Failed to save location.")
            } else {
                self.createAlert(title: "Successs", message: "Location updated.")
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
