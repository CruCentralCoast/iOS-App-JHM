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
    var subbedMinistries = [Ministry]()
    var filteredCampuses = [Campus]()
    var resultSearchController: UISearchController!
    var lastTappedPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBUtils.loadResources("campus", inserter: insertCampus)
        subbedMinistries = SubscriptionManager.loadMinistries()! 
        
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
    
    func refreshSubbedMinistries(){
        subbedMinistries = SubscriptionManager.loadMinistries()! 
    }
    
    
    
    func insertCampus(dict : NSDictionary) {
        self.tableView.beginUpdates()
        
        let campusName = dict["name"] as! String
        let campusId = dict["_id"] as! String
        
        let curCamp = Campus(name: campusName, id: campusId)
        if (SubscriptionManager.loadCampuses() != nil){
            let enabledCampuses = SubscriptionManager.loadCampuses()!
            if(enabledCampuses.contains(curCamp)){
                curCamp.feedEnabled = true
            }
        }
    
        campuses.insert(curCamp, atIndex: 0)
        campuses.sortInPlace()
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        SubscriptionManager.saveCampuses(campuses)
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
                let theCampus = campuses[indexPath.row]
                
                if(!willAffectMinistrySubscription(theCampus)){
                    cell.accessoryType = .None
                    theCampus.feedEnabled = false
                }
                else{
                    lastTappedPath = indexPath
                }
            }
            else{
                cell.accessoryType = .Checkmark
                campuses[indexPath.row].feedEnabled = true
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        //TODO - Make is so this doesn't have to be called everytime didSelectRowAtIndexPath is called
        SubscriptionManager.saveCampuses(campuses)
    }
    
    
    func willAffectMinistrySubscription(campus: Campus)->Bool{
        var associatedMinistries = [Ministry]()
        
        for ministry in subbedMinistries{
            if(SubscriptionManager.campusContainsMinistry(campus, ministry: ministry)){
                associatedMinistries.append(ministry)
            }
        }
        
        if(associatedMinistries.isEmpty == false){
            var alertMessage = "Unsubscribing from " + campus.name + " will also unsubscribe you from the following ministries: "
            
            for ministry in associatedMinistries{
                alertMessage += ministry.name + ", "
            }
            
            let index: String.Index = alertMessage.startIndex.advancedBy(alertMessage.characters.count - 2)
            alertMessage = alertMessage.substringToIndex(index)
            
            let alert = UIAlertController(title: "Are you sure?", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: .Destructive, handler: handleConfirmUnsubscribe))
            presentViewController(alert, animated: true, completion: nil)
            
            return true
        }
        else{
            return false
        }
    }
    
    func handleConfirmUnsubscribe(action: UIAlertAction){
        if(lastTappedPath != nil){
            if let cell = tableView.cellForRowAtIndexPath(lastTappedPath){
                let theCampus = campuses[lastTappedPath.row]
                cell.accessoryType = .None
                theCampus.feedEnabled = false
            }
        }
        //TODO: Actual unsubscribe the user from the associated ministries
    }
}
