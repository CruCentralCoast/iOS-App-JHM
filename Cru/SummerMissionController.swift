//
//  SummerMissionController.swift
//  Cru
//
//  Created by Quan Tran on 2/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation
import UIKit


class SummerMissionController: UICollectionViewController {
    
    //MARK: Constants
    private let dbCollectionName = "summermission"
    private let reuseIdentifier = "SummerMissionCell"
    
    //MARK: Properties
    private var missions: [SummerMission] = Array()
    var startTime:Int!
    var endTime:Int!
    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load summer missions from database
        startTime = Int(NSDate().timeIntervalSince1970)
        ServerUtils.loadResources(dbCollectionName, inserter: insertMission, afterFunc: reload)
        
        // set background
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView!.backgroundColor = UIColor.blackColor()
    }
    
    // Creates and inserts a SummerMission into this collection view from the given dictionary.
    func insertMission(dict : NSDictionary) {
        self.missions.insert(SummerMission(dict: dict)!, atIndex: 0)
    }
    
    // Signals the collection view to reload data.
    func reload() {
        self.collectionView?.reloadData()
        endTime = Int(NSDate().timeIntervalSince1970)
        print("Fetching missions took " + String(endTime - startTime) + " seconds.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        this don't work yet
        
        let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
        if let selectedEventCell = sender as? EventTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedEventCell)!
            let selectedEvent = events[indexPath.row]
            eventDetailViewController.event = selectedEvent
        }
        */
        
    }
}

// UICollectionViewDataSource conformance
extension SummerMissionController {
    // The collection only has one section.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Gets the total number of SummerMissions in the collection view.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    // Gets the cell at the given index path in the collection view.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SummerMissionCell
        
        // set the mission for the given cell
        cell.mission = missions[indexPath.row]
        
        return cell
    }
}