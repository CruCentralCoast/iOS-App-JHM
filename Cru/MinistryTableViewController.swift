//
//  CampusesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTableViewController: UITableViewController {
    var ministries = [Ministry]()            //list of ALL ministries
    var subscribedCampuses = [Campus]()      //list of subscribed campuses
    var ministryMap = [Campus: [Ministry]]() //map of all subscribed campsuses to their respective ministries
    var prevMinistries = [Ministry]()        //list of previously subscribed ministries (saved on device)
    
    
    override func viewWillAppear(animated: Bool) {
        reloadCampuses()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let campuses = SubscriptionManager.loadCampuses()
        if(campuses != nil){
            subscribedCampuses = campuses!
        }
        
        let tempMinistries = SubscriptionManager.loadMinistries()
        if(tempMinistries != nil){
            prevMinistries = tempMinistries!
        }

        DBUtils.loadResources(Config.ministryCollection, inserter: insertMinistry, afterFunc: reloadCampuses)
        self.tableView.reloadData()
    }
    
    func reloadCampuses(){
        super.viewDidLoad()
        subscribedCampuses = SubscriptionManager.loadCampuses()!
        refreshMinistryMap()
        self.tableView.reloadData()
        
    }
    
    
    func refreshMinistryMap() {
        ministryMap.removeAll()
        for ministry in ministries {
            for campus in subscribedCampuses {
                if(SubscriptionManager.campusContainsMinistry(campus, ministry: ministry)) {
                    if (ministryMap[campus] == nil){
                        ministryMap[campus] = [ministry]
                    }
                    else{
                        ministryMap[campus]!.insert(ministry, atIndex: 0)
                    }
                }
            }
        }
    }
    
    
    func insertMinistry(dict : NSDictionary) {
        let ministryName = dict[Config.name] as! String
        let campusIds = dict[Config.campusIds] as! [String]
        let newMinistry = Ministry(name: ministryName, campusIds: campusIds)
        
        if(prevMinistries.contains(newMinistry)){
            newMinistry.feedEnabled = true
        }
        
        ministries.insert(newMinistry, atIndex: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        var subscribedMinistries = [Ministry]()
        
        for campus in subscribedCampuses{
            let campusMinistries = ministryMap[campus]
            if (campusMinistries != nil) {
                for ministry in campusMinistries! {
                    if(ministry.feedEnabled == true){
                        subscribedMinistries.append(ministry)
                    }
                }
            }
        }
        SubscriptionManager.saveMinistrys(subscribedMinistries)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return subscribedCampuses.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subscribedCampuses[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let campus = subscribedCampuses[section]
        return ministryMap[campus] == nil ? 0 : ministryMap[campus]!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ministryCell", forIndexPath: indexPath)
        
            let ministry = getMinistryAtIndexPath(indexPath)
        
            cell.textLabel?.text = ministry.name
        
            print("feed for \(ministry.name) is \(ministry.feedEnabled)")
            if(ministry.feedEnabled == true){
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let ministry = getMinistryAtIndexPath(indexPath)
            
            if(cell.accessoryType == .Checkmark){
                cell.accessoryType = .None
                ministry.feedEnabled = false
            }
            else{
                cell.accessoryType = .Checkmark
                ministry.feedEnabled = true
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    func getMinistryAtIndexPath(indexPath: NSIndexPath)->Ministry{
        let row = indexPath.row
        let section = indexPath.section
        return ministryMap[subscribedCampuses[section]]![row]
    }
    
}
