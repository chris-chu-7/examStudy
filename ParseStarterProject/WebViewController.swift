//
//  WebViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var URLWindow: UIWebView! //web view to show the link displayed in the uitableview
    
    @IBOutlet weak var link: UITextView! //view for the user to copy the link to study
    
    var myString = String() //string that contains the website url
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        link.text = myString //assign the link to the url from the UITableView
        
        if let url = URL(string: myString){
            URLWindow.loadRequest(URLRequest(url: url)) //load the URLRequest onto the webView
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backFromURL", sender: self)
    }
    
    
}
