//
//  searchViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    @IBOutlet weak var search: UISearchBar! //search bar
    @IBOutlet weak var classList: UITableView! //table view
    
    
    var isSearching = false //boolean placeholder
    var array:[String] = [] //contains array of all the classes
    var filteredData:[String] = [" "] //filtered data
    
    @IBAction func backButton(_ sender: Any) {
       performSegue(withIdentifier: "fromSearch", sender: self) //go back to the home page
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        classList.delegate = self
        classList.dataSource = self
        
        let query = PFQuery(className: "Classes") //look in classes
        query.whereKey("name", notEqualTo: " ")
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
               print("cannot retrieve classes")
            } else {
                for object in objects!{
                    self.array.append(object["name"] as! String) //add all the classes to the tableView
                    self.classList.reloadData() //load the table
                }
            }
        })
        
        search.returnKeyType = UIReturnKeyType.done //a way to dismiss the search pad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if isSearching{
            return filteredData.count //if searching, filter the data
        }
        return array.count //else, show all the classes
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DataCell{
            let text: String!
            if isSearching{
                text = filteredData[indexPath.row] //filter the data if searching
            } else {
                text = array[indexPath.row]
            }
            cell.configureCell(text: text) //else, show all the classes
            return cell
        }
        else {
            return UITableViewCell() //else if fails, return a default cell (error prevention)
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            classList.reloadData() //if the search bar is empty, set the user as not searching
        } else {
            isSearching = true //if searching, set the user is searching
            filteredData = array.filter({ (array:String) -> Bool in
                if array.contains(search.text!) || array.contains(search.text!.lowercased()){ //see if the search contains a character or a string of characters
                    return true
                } else {
                    return false
                }
            })
            classList.reloadData()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true) //return key
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.search.endEditing(true) //touch key
    }
    
    
}
