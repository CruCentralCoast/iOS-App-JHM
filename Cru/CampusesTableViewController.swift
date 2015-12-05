//
//  CampusesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class CampusesTableViewController: UITableViewController, UISearchResultsUpdating {
    var campuses = [Campus]()
    var filteredCampuses = [Campus]()
    var resultSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBUtils.loadResources("campus", inserter: insertCampus)
        
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.hidesNavigationBarDuringPresentation = false

        self.tableView.tableHeaderView = self.resultSearchController.searchBar

        self.tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredCampuses.removeAll(keepCapacity: false)
        let query = searchController.searchBar.text!.lowercaseString
        
        for campy in campuses{
            if(campy.name.lowercaseString.containsString(query)){
                filteredCampuses.append(campy)
            }
        }
        
        if(query == ""){
            filteredCampuses = campuses
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func insertCampus(dict : NSDictionary) {
        self.tableView.beginUpdates()
        let curCamp = Campus(name: dict["name"] as! String)
        if (loadCampuses() != nil){
            let enabledCampuses = loadCampuses()!
            if(enabledCampuses.contains(curCamp)){
                curCamp.feedEnabled = true
            }
        }
    
        campuses.insert(curCamp, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveCampuses(campuses)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active{
            return self.filteredCampuses.count
        }
        else{
            return self.campuses.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("campusCell", forIndexPath: indexPath)
        
        if self.resultSearchController.active{
            cell.textLabel?.text = filteredCampuses[indexPath.row].name
            if(filteredCampuses[indexPath.row].feedEnabled == true){
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
        }
        else{
            cell.textLabel?.text = campuses[indexPath.row].name
            if(campuses[indexPath.row].feedEnabled == true){
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if(cell.accessoryType == .Checkmark){
                cell.accessoryType = .None
                campuses[indexPath.row].feedEnabled = false
            }
            else{
                cell.accessoryType = .Checkmark
                campuses[indexPath.row].feedEnabled = true
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func saveCampuses(campuses:[Campus]) {
        var enabledCampuses = [Campus]()
        
        for camp in campuses{
            if(camp.feedEnabled == true){
                enabledCampuses.append(camp)
            }
        }
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabledCampuses as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: "campusKey")
        defaults.synchronize()
    }
    
    func loadCampuses() -> [Campus]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("campusKey") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]
        }
        return nil
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
