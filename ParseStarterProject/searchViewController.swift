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
    

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var classList: UITableView!
    
    
    var isSearching = false
    var array:[String] = []
    var filteredData:[String] = [" "]
    
    @IBAction func backButton(_ sender: Any) {
       performSegue(withIdentifier: "fromSearch", sender: self)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        classList.delegate = self
        classList.dataSource = self
        
        let query = PFQuery(className: "Classes")
        query.whereKey("name", notEqualTo: " ")
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil{
               print("cannot retrieve classes")
            } else {
                for object in objects!{
                    self.array.append(object["name"] as! String)
                    self.classList.reloadData()
                }
            }
        })
        
        search.returnKeyType = UIReturnKeyType.done
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if isSearching{
            return filteredData.count
        }
        return array.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DataCell{
            let text: String!
            if isSearching{
                text = filteredData[indexPath.row]
            } else {
                text = array[indexPath.row]
            }
            cell.configureCell(text: text)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            classList.reloadData()
        } else {
            isSearching = true
            filteredData = array.filter({ (array:String) -> Bool in
                if array.contains(search.text!) || array.contains(search.text!.lowercased()){
                    return true
                } else {
                    return false
                }
            })
            classList.reloadData()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.search.endEditing(true)
    }
    
    
    
    
    
}
