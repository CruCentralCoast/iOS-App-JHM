//
//  CampusesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTableViewController: UITableViewController {
    var ministries = [Ministry]()
    var campuses = [Campus]()
    var ministryMap = [Campus: [Ministry]]()
    
    override func viewDidAppear(animated: Bool) {
        print("table appeared")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campuses = SubscriptionManager.loadCampuses()!
        DBUtils.loadResources("ministry", inserter: insertMinistry)
        self.tableView.reloadData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func reloadCampuses(){
        super.viewDidLoad()
        
        
//        ministries.removeAll()
        
        campuses = SubscriptionManager.loadCampuses()!
        refreshMinistryMap()
        //DBUtils.loadResources("ministry", inserter: insertMinistry)
        
        self.tableView.reloadData()
        print("reloaded campuses")
    }
    
    func refreshMinistryMap() {
        ministryMap.removeAll()
        for ministry in ministries {
            for campus in campuses {
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
        let ministryName = dict["name"] as! String
        let campusIds = dict["campuses"] as! [String]
        let newMinistry = Ministry(name: ministryName, campusIds: campusIds)
        ministries.insert(newMinistry, atIndex: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //SubscriptionManager.saveMinistrys(ministries)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return campuses.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return campuses[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let campus = campuses[section]
        return ministryMap[campus] == nil ? 0 : ministryMap[campus]!.count
        
//        let campus = campuses[section]
//        var count = 0
//        
//        for ministry in ministries{
//            for campusId in ministry.campusIds{
//                if(campusId == campus.id){
//                    count++
//                }
//            }
//        }
//        
//        print("\(count) rows for campus \(campus.name)")
//        return count
        //return ministries.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ministryCell", forIndexPath: indexPath)
        
            let row = indexPath.row
            let section = indexPath.section
        
            let ministry = ministryMap[campuses[section]]![row]
            cell.textLabel?.text = ministry.name
        
            //cell.textLabel?.text = ministries[indexPath.row].name
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
//            if(cell.accessoryType == .Checkmark){
//                cell.accessoryType = .None
//                ministries[indexPath.row].feedEnabled = false
//            }
//            else{
//                cell.accessoryType = .Checkmark
//                ministries[indexPath.row].feedEnabled = true
//            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
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