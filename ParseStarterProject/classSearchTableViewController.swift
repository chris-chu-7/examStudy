//
//  classSearchTableViewController.swift
//  
//
//  Created by Christopher Chu on 7/21/17.
//

import UIKit
import Parse

class classSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var stump = [String]()
    var filteredArray = [String]()
    var searchController = UISearchController()
    var resultsController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(stump)
        
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = stump.filter({ (array:String) -> Bool in
            if array.contains(searchController.searchBar.text!){
                return true
            } else {
                return false
            }
        })
        
        resultsController.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func goBack(_ sender: Any) {
        
        performSegue(withIdentifier: "fromClassSearch", sender: self)
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == resultsController.tableView{
            return filteredArray.count
        } else {
            return stump.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        if tableView == resultsController.tableView{
            cell.textLabel?.text = filteredArray[indexPath.row]
        } else {
            cell.textLabel?.text = stump[indexPath.row]
        }
        return cell
    }
    
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
}
