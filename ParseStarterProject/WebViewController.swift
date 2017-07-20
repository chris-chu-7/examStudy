//
//  WebViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var URLWindow: UIWebView!
    
    @IBOutlet weak var link: UITextView!
    
    var myString = String()
    var linked = "https://www.google.com"
    
    //label.text = myString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        link.text = myString
        
        if let url = URL(string: myString){
            URLWindow.loadRequest(URLRequest(url: url))
        } else {
            let url = URL(string: linked)
            URLWindow.loadRequest(URLRequest(url: url!))
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backFromURL", sender: self)
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
