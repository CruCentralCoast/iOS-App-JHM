//
//  SummerMissionCollectioneViewController.swift
//  Cru
//
//  Created by Quan Tran on 2/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation
import UIKit

class SummerMissionCollectionViewController: UICollectionViewController {
    //MARK: Properties
    private let reuseIdentifier = "MissionCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var missions: [SummerMission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ofsadgkn")
        //delegate = nil
        ServerUtils.loadResources("summermission", inserter: insertMission)
    }
    
    func insertMission(dict : NSDictionary) {
        self.missions.insert(SummerMission(dict: dict)!, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
*/
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SummerMissionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SummerMissionCollectionViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let mission = missions[indexPath.row]
        
        //Creating the abbreviated version of the month to be displayed
        /*
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        let monthShort = months[event.month!-1]
        
        cell.monthLabel.text = monthShort.uppercaseString
        
        cell.dateLabel.text = String(event.startDay!)
        */
        cell.nameLabel.text = mission.name
        
        return cell
    }
    */
    
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
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
        if let selectedEventCell = sender as? EventTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedEventCell)!
            let selectedEvent = events[indexPath.row]
            eventDetailViewController.event = selectedEvent
        }
        */
        
    }
}

// UICollectionViewDelegateFlowLayout conformance
extension SummerMissionCollectionViewController {
    //1
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            /*
            let flickrPhoto =  photoForIndexPath(indexPath)
            //2
            if var size = flickrPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
            }
*/
            return CGSize(width: 200, height: 100)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}

// UICollectionViewDataSource conformance
extension SummerMissionCollectionViewController {
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return missions.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SummerMissionCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        // Configure the cell
        return cell
    }
}